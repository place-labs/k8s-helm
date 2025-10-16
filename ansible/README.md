# Example PlaceOS Complex Deployment

Example provisioning PlaceOS and third party helm charts in a more "production like" deployment using Ansible.

Contains 4 roles:

- `placeos.helm`: deploy the core PlaceOS charts without thirdparty services
- `placeos.helm.thirdparty`: deploy the thirdparty services
- `placeos.helm.releasevars`: retreive existing chart release vars to prevent regenerating passwords for rethinkdb
- `placeos.networkpolicies` : create k8s network polices for the deployed resources. Note: Does not work with k3d without modifying the default SDN.eg By switching to Calico SDN

## Prerequisites

- Ansible >= 2.17 on Python 3

- Openshift python library. To install `pip install openshift`

- Install the kubernetes.core Ansible collection: `ansible-galaxy collection install kubernetes.core`

- Review the requirements for the [Ansible helm wrapper](https://docs.ansible.com/ansible/2.10/collections/kubernetes.core/helm_module.html)

- GKE: a Cloud Armor Security must exist for the Load Balancer to associate with

Note: Tested with:

- Ansible: 2.17
- Ansible collection: `kubernetes.core:6.0.0`
- Kubernetes: 1.27 - 1.33
- Helm: v3.17.3

## Executing

To deploy:

```sh
# Install reprequisites
ansible-galaxy collection install kubernetes.core

# Update helm dependencies from charts directory
helm dependency update ./charts/placeos

# Move to the directory where the placeos.yaml playbook exists
cd ansible
```

Set cluster info values in the relevant inventory `host_vars/k8s.yaml` file:
(or use `-e` flags to set when running the playbook)

```yaml
# Cluster Info ConfigMap (used by admins and upgrade jobs)
cluster_info:
  name: "default" # eg. PlaceOS PROD
  environment: "default" # eg. production, staging, development
  region: "default" # eg. australiaeast
```

### Local deployment to k3d
```sh
# Check first be for deploying
ansible-playbook placeos.yaml -i inventories/k3d/ --check
ansible-playbook placeos.yaml -i inventories/k3d/
```


### GKE deployment
```sh
# Set the Cloud Armor security policy name in inventories/gke/host_vars/k8s.yaml as placeos.global.gcpbackendConfig.config.securityPolicy
# Check first be for deploying
ansible-playbook placeos.yaml -i inventories/gke/  --check
# Define the placeDomain value when running:
# Terraform will output the created External IP or find `l7-ip` at `VPC Network -> External IP Addresses`
ansible-playbook placeos.yaml -i inventories/gke/ -e "placeDomain={domain/{external IP.sslip.io}}"
ansible-playbook placeos-network-policies.yaml -e "gke=true"
```

### AKS deployment
```sh
# Check first be for deploying
ansible-playbook placeos.yaml -i inventories/aks/  --check

# Deploy with public IP
ansible-playbook placeos.yaml -i inventories/aks/
# Deploy with internal IP
ansible-playbook placeos.yaml -i inventories/aks/ -e "internalLB=true"

ansible-playbook placeos-network-policies.yaml
```

### AWS deployment
```sh
# Check first be for deploying
ansible-playbook placeos.yaml -i inventories/gke/  --check
# Define the placeDomain value when running:
ansible-playbook placeos.yaml -i inventories/gke/ -e "placeDomain={domain/{external IP.sslip.io}}"
ansible-playbook placeos-network-policies.yaml
```

To cleanup:

```sh
ansible-playbook placeos.yaml -i inventories/k3d/ -e "chart_state=absent"
ansible-playbook placeos.yaml -i inventories/aks/ -e "chart_state=absent"
ansible-playbook placeos.yaml -i inventories/gke/ -e "chart_state=absent"

ansible-playbook placeos-network-policies.yaml  -e "policy_state=absent"

# Note: you will also need to clean up the PVs created by the StatefulSets manually
# Secrets and Configmaps for PlaceOS are not deleted in the clean up

```

## Limitations

The role `placeos.helm.releasevars` is a convenience method to prevent overiding the rethinkdb password.

In a real world situation the admin password would not be shared

Each charts should be managed seperately as seperate playbooks.

Make sure to delete PVCs left over by StatefulSets when when uninstalling charts
