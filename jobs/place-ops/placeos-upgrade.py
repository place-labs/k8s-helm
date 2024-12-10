# Add to the cluster with `kubectl create configmap placeos-upgrade --from-file=placeos-upgrade.py`
import os
import subprocess
import json
import time
import sys

# cronjob names
backup_job = "placeos-backup"
migrations_job = "placeos-migrations"

def puts(message):
    print(f"PLACEOS: {message}", flush=True)

def run_cmd(cmd):
    try:
        return subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT).decode('utf-8')
    except subprocess.CalledProcessError as e:
        puts(f"Error executing command: {cmd}\nError: {e.output.decode('utf-8')}")
        sys.exit(1)

def run_job_from_cron(job, namespace):
    subprocess.run(f"kubectl create job -n {namespace} --from=cronjob/{job} {job}", shell=True, check=True)

    puts("Waiting for job to complete...")
    while True:
        time.sleep(5)
        json_status = run_cmd(f"kubectl get job {job} -n {namespace} -o jsonpath='{{.status.conditions}}'")

        if not json_status:
            continue

        try:
            conditions = json.loads(json_status)
        except json.JSONDecodeError:
            puts("Error parsing job status.")
            continue

        condition_types = [condition.get('type') for condition in conditions]

        if "Complete" in condition_types:
            puts(f"Job {job} completed successfully.")
            break

        if "Failed" in condition_types:
            puts(f"Job {job} failed.")
            sys.exit(1)

def backup_database(namespace):
    run_job_from_cron(backup_job, namespace)

def migrate_database(namespace):
    run_job_from_cron(migrations_job, namespace)

def get_placeos_resources(namespace):
    resources = []
    for resource_type in ["statefulsets", "deployments"]:
        cmd = f"kubectl get {resource_type} -l app.kubernetes.io/instance=placeos -n {namespace} -o json"
        output = json.loads(run_cmd(cmd))
        for item in output['items']:
            resources.append({
                "type": resource_type,
                "name": item['metadata']['name'],
                "replicas": item['spec'].get('replicas'),
                "annotations": item['metadata'].get('annotations', {})
            })
    return resources

def scale_down(namespace, resources):
    for resource in resources:
        if resource['replicas'] > 0:
            # Annotate with current replicas only if not previously annotated
            if "replicas-before-upgrade" not in resource['annotations']:
                run_cmd(f"kubectl annotate {resource['type']} {resource['name']} -n {namespace} replicas-before-upgrade={resource['replicas']} --overwrite")
                # also update the local copy for the scale up command
                resource['annotations']['replicas-before-upgrade'] = resource['replicas']
            # Scale down
            run_cmd(f"kubectl scale {resource['type']} {resource['name']} --replicas=0 -n {namespace}")

def scale_up(namespace, resources):
    for resource in resources:
        original_replicas = resource['annotations'].get("replicas-before-upgrade")
        if original_replicas:
            run_cmd(f"kubectl scale {resource['type']} {resource['name']} --replicas={original_replicas} -n {namespace}")
            run_cmd(f"kubectl annotate {resource['type']} {resource['name']} -n {namespace} replicas-before-upgrade-")

def patch_resource(resource_name, resource_type, namespace, new_version):
    puts(f"Updating {resource_name} to version {new_version}")
    if not resource_name:
        puts("resource_name is not provided")
        return 1

    # Get the indexes of the container(s) with "placeos" in their image tag
    cmd_get_image_indexes = (
        f"kubectl get {resource_type} {resource_name} -n {namespace} "
        f"-o jsonpath=\"{{range .spec.template.spec.containers[*]}}{{.image}}{{'\\n'}}{{end}}\" "
        "| grep -n 'placeos' | cut -d':' -f1"
    )

    container_indexes = run_cmd(cmd_get_image_indexes).split()

    for index in container_indexes:
        # Minus 1 from the index value (because grep -n starts at 1) to get the correct index in the containers list
        current_image = run_cmd(f"kubectl get {resource_type} {resource_name} -n {namespace} -o jsonpath='{{.spec.template.spec.containers[{int(index)-1}].image}}'")
        current_image_name = current_image.split(':')[0]
        new_image = f"{current_image_name}:{new_version}"

        patch_json = [
            {"op": "replace", "path": "/metadata/labels/app.kubernetes.io~1version", "value": new_version},
            {"op": "replace", "path": "/spec/template/metadata/labels/app.kubernetes.io~1version", "value": new_version},
            {"op": "replace", "path": f"/spec/template/spec/containers/{int(index)-1}/image", "value": new_image},
        ]
        patch_str = str(patch_json).replace("'", "\"")
        patch_cmd = (
            f"kubectl patch {resource_type} {resource_name} -n {namespace} --type='json' "
            f"--patch='{patch_str}'"
        )
        
        try:
            subprocess.run(patch_cmd, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Failed to patch resource: {e}")

def upgrade_placeos(namespace, resources, new_version):
    # Patch the placeos-migrations cron job
    patch_placeos_migrations_cmd = f"kubectl patch cronjob placeos-migrations -n {namespace} --type='json' " + \
                                  f"""-p='[{{"op": "replace", "path": "/spec/jobTemplate/spec/template/spec/containers/0/image", "value": "placeos/init:{new_version}"}}]'"""
    puts("Patching placeos-migrations: ")
    subprocess.run(patch_placeos_migrations_cmd, shell=True, check=True)

    # Run the placeos-migrations job
    puts("Running placeos-migrations: ")
    migrate_database(namespace)

    # Patch the placeos statefulsets and deployments
    for resource in resources:
      patch_resource(resource['name'], resource['type'], namespace, new_version)

def main():
    namespace = os.getenv('NAMESPACE')
    new_version = os.getenv('NEW_VERSION')
    if not namespace:
        puts("NAMESPACE is not set. This shouldn't happen unless something changes in the kubernetes api")
        sys.exit(1)
    if not new_version:
        puts("NEW_VERSION is not set. The configmap `cluster-info` with key `version` matching the image tag to deploy must exist in the namespace.")
        sys.exit(1)

    puts(f"Beginning database backup in namespace: {namespace}")
    backup_database(namespace)
    puts("Database backup complete")

    puts("Retrieving resources...")
    resources = get_placeos_resources(namespace)
    puts(f"Retrieved resources: {resources}")

    if not resources:
        puts("No PlaceOS resources found in the namespace. Exiting...")
        sys.exit(1)

    puts("Scaling down resources")
    scale_down(namespace, resources)

    puts(f"Upgrading PlaceOS to version {new_version}")
    upgrade_placeos(namespace, resources, new_version)
    puts("Upgrade complete")

    puts("Scaling up resources")
    scale_up(namespace, resources)

if __name__ == "__main__":
    main()
