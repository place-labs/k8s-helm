# PlaceOS Metrics

## Configure

Deployment values for each service can be set in `values.yaml`  
See the github links inside for full lists of options

### Useful values:

`grafana.ingress`
```
enabled: true # create an ingress to grafana or not
hostname: metrics.dev.example.com # (sub)domain pointing to your k8s ingress
annotations: {} # ingress annotations can be applied here
tls: true # creates a self signed cert as defined below
selfSigned: true # see the github link above for other tls options
```

`grafana.admin`
```
user: admin-username # this user will be able log in via the ingress above
password: admin-password # if left blank will create a random 10 character string in secret `metrics-grafana-admin`
```

`grafana.datasources`  
A secret containing the contents of the datasources yaml files is created on helm install
- [Secret Template](templates/grafana-datasources-secret.yaml.tpl)
- [Grafana Datasources](grafana-provisioning/datasources/)

Grafana will apply these on pod creation
```
secretName: # the name of the secret created by the template file
```

Several services have persistence available.  
For dev deployments, most are disabled and all are set to minimal sizes:
```
kube-prometheus:
  persistence:
    size: 100M

grafana:
  persistence:
    size: 100M

grafana-loki:
  compactor:
    persistence:
        enabled: false
        size: 100M
  ingester:
    persistence:
        enabled: true
        size: 100M
  querier:
    persistence:
        enabled: false
        size: 100M

grafana-tempo:
  ingester:
    persistence:
        enabled: true
        size: 100M
```

---

## Install
```
helm install metrics . -f values.yaml -n placeos-metrics --create-namespace --set grafana.ingress.hostname="metrics.dev.example.com"
```

## Upgrade
- Make sure to set the grafana password
```
helm upgrade --install metrics . -f values.yaml -n placeos-metrics --create-namespace --set grafana.ingress.hostname="metrics.dev.example.com" --set grafana.admin.password="existing-password"
```