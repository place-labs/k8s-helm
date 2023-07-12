# Jobs

---

## init

Run the init job to:
- Check for and perform required database migrations (recommended after each PlaceOS version update)

If required, a new PlaceOS `domain`, `user` & backoffice `application` can be created by setting these ENV variables on the pod:
- `PLACE_SKIP_PLACEHOLDERS: false`
- `PLACE_DOMAIN: ` domain to create

To run the init job:

1. Edit init.yaml
 - Set the `image` to the same PlaceOS version as deployed PlaceOS services
 - Set `PLACE_SKIP_PLACEHOLDERS` & `PLACE_DOMAIN` if required as above


2. Apply init.yaml (`namespace` may differ)
```
kubectl apply --filename init.yaml --namespace placeos
```

- The `init` pod logs will contain details about any migrations performed or entities created and will remain for 1 hour

---

## rethink-dump

Run the rethink-dump job to:
- Export the rethink database

To run the rethink-dump job:

1. Apply rethink-dump.yaml
```
kubectl apply --filename rethink-dump.yaml --namespace placeos
```

- The `rethink-dump` pod logs will contain output of the backup performed and output the kubectl command to copy it out of the cluster

---


## postgres-dump

Run the postgres-dump job to:
- Export the postgres database

To run the postgres-dump job:

1. Apply postgres-dump.yaml
```
kubectl apply --filename postgres-dump.yaml --namespace placeos
```

- The `postgres-dump` pod logs will output the kubectl command to copy it out of the cluster
- The dump will be created in the postgresql-0 pod in /tmp - bash into that pod to check if there are issues

---
## init-postgres

Run the init-postgres job to:
- Initialize a postgres database before migrating from RethinkDB

To run the init-postgres job:

1. Create a `postgres-client` configMap and secret
  - These will be used by PlaceOS pods after migration so it is convenient to create and use them now
  - Check the Service name for postgres in the cluster to set as the `PG_HOST`
  - `kubectl apply` the configMap:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: postgres-client
  namespace: placeos
data:
  PG_DB: placeos
  PG_HOST: postgresql
  PG_PORT: "5432"
  PG_USER: placeos
  PG_QUERY: "?initial_pool_size=1&max_pool_size=20&retry_attempts=2"
```
  - Create a secret named `postgres-client` with a key `PG_PASSWORD` set to the postgres placeos users password in the `placeos` Namespace

2. Apply init-postgres.yaml
```
kubectl apply --filename init-postgres.yaml --namespace placeos
```

- The `init-postgres` pod logs will output the results of the task

---
## migrate-rethink-postgres

Run the migrate-rethink-postgres job to:
- Import a RethinkDB backup to a Postgres database.

To run the migrate-rethink-postgres job:

1. Create a `postgres-client` configMap and secret as done for `init-postgres` Job if they do not exist

2. Create a PVC and put the rethink backup file on it if not already done
- Create PVC
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: backup
  namespace: placeos
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: default
  volumeMode: Filesystem
```
- Attach PV to a pod
```
apiVersion: v1
kind: Pod
metadata:
  name: backup-volume
  namespace: placeos
spec:
  containers:
    - name: alpine
      image: alpine
      command: ["sleep", "infinity"]
      volumeMounts:
        - name: backup
          mountPath: /backup
  volumes:
    - name: backup
      persistentVolumeClaim:
        claimName: backup
```
- Copy backup to it
```
kubectl cp --namespace placeos ./rethink-dump-xx.tar.gz backup-volume:/backup/rethink-dump.tar.gz
```
- Delete the pod
```
kubectl delete -n placeos pod backup-volume
```

3. Apply migrate-rethink-postgres.yaml
```
kubectl apply --filename migrate-rethink-postgres.yaml --namespace placeos
```

- The `migrate` pod logs will output the progress/results of the migration