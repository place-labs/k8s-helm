# PlaceOS Metrics

Deploys a stack of monitoring services with configured data sources and dashboards for metrics, logging, tracing & alerting to a PlaceOS kubernetes cluster

| Metrics               | Logging   | Tracing   | Alerting      |
| --                    | --        | --        | --            |
| Prometheus            | Grafana   | Tempo     | Alert Manager |
| Node Exporter         | Loki      |           |               |
| Kube State Metrics    | Promtail  |           |               |
| Memcached             |           |           |               |

## Configure

### PlaceOS services need to be logging in JSON format for some dashboards
- set environment variable:
```
PLACE_LOG_FORMAT: JSON
```

Deployment values for each service can be set in `values.yaml`  or `helm install --set`  
See the chart readme / values.yaml files for full lists of options and usage:
- [kube-prometheus](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)
- [grafana](https://github.com/bitnami/charts/tree/main/bitnami/grafana)
- [grafana-loki](https://github.com/bitnami/charts/tree/main/bitnami/grafana-loki)
- [grafana-tempo](https://github.com/bitnami/charts/tree/main/bitnami/grafana-tempo)

### Useful values:

#### Grafana Ingress
`grafana.ingress`
```
enabled: true # create an ingress to grafana or not
hostname: metrics.dev.example.com # (sub)domain pointing to your k8s ingress
annotations: {} # ingress annotations can be applied here
tls: true # creates a self signed cert as defined below
selfSigned: true # see the github link above for other tls options
```

---

#### Grafana Login
`grafana.admin`
```
user: admin-username # this user will be able log in via the ingress above
password: admin-password # if left blank will create a random 10 character string in secret `metrics-grafana-admin`
```

---

#### Grafana Datasources
`grafana.datasources`  
A secret containing the contents of the datasources yaml files is created on helm install
- [Secret Template](templates/grafana-datasources-secret.yaml.tpl)
- [Grafana Datasources](grafana-provisioning/datasources/)
- [Grafana Provisioning Documentation](https://grafana.com/docs/grafana/latest/administration/provisioning/#example-data-source-config-file)

Grafana will apply these on pod creation
```
secretName: # the name of the secret created by the template file
```

---

#### Grafana Dashboards
`grafana.dashboardsProvider`
```
enabled: true # enables the deafult Grafana dashbaord providor which loads the dashboard files from the volume mount into a single folder
configMapName: placeos-grafana-dashboard-provider # The name of a configmap containing a Grafana dashboard provider yaml file to use instead of the default
```
We use the default provider yaml with one modification, enabling creation of the dashboard directory structure in Grafana.
- [Provider Template](templates/placeos-grafana-dashboard-provider-configmap.yaml.tpl)
- [Grafana Provisioning Documentation](https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards)


The dashboard files themselves are loaded as seperate configmaps (the template will create one configmap for each json file in the dashboards folder and subfolders) which are then configure individually on the Grafana service in `grafana.dashboardsConfigMaps`
- [Dashboards Template](templates/placeos-grafana-dashboards-configmap.yaml.tpl)
- [Grafana Dashboards](grafana-provisioning/dashboards/)

`grafana.dashboardsConfigMaps`

A list of configmap names containing dashboard json files
```
fileName: needs to match the key in the configmap
folderName: defines the Grafana Dashboards folder to place the dashboard in
```
- [Dashboards definitions in values.yaml](https://github.com/place-labs/k8s-helm/blob/feat/metrics/charts/metrics/values.yaml#LL32C1-L59C1)

---

## Persistence

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
