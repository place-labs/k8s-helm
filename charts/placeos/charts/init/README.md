# init

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

A PlaceOS helm chart for the Init component

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.ENV | string | `nil` | value exposed as environment variable to the pod |
| config.ES_HOST | string | `nil` | value exposed as environment variable to the pod |
| config.ES_PORT | int | `0` | value exposed as environment variable to the pod |
| config.PLACE_APPLICATION | string | `nil` | value exposed as environment variable to the pod |
| config.PLACE_AUTH_HOST | string | `nil` | value exposed as environment variable to the pod |
| config.PLACE_EMAIL | string | `nil` | value exposed as environment variable to the pod |
| config.PLACE_PASSWORD | string | `nil` | value exposed as environment variable to the pod |
| config.PLACE_TLS | bool | `true` | value exposed as environment variable to the pod |
| config.PLACE_USERNAME | string | `nil` | value exposed as environment variable to the pod |
| config.RETHINKDB_DB | string | `nil` | value exposed as environment variable to the pod |
| config.RETHINKDB_HOST | string | `nil` | value exposed as environment variable to the pod |
| config.RETHINKDB_PASSWORD | string | `nil` | value exposed as environment variable to the pod |
| config.RETHINKDB_PORT | int | `0` | value exposed as environment variable to the pod |
| config.RETHINKDB_USER | string | `nil` | value exposed as environment variable to the pod |
| config.SG_ENV | string | `nil` | value exposed as environment variable to the pod |
| config.TZ | string | `"Australia/Sydney"` | value exposed as environment variable to the pod |
| deployment.fullnameOverride | string | `""` |  |
| deployment.image.pullPolicy | string | `"IfNotPresent"` |  |
| deployment.image.repository | string | `"placeos/init"` |  |
| deployment.imagePullSecrets | list | `[]` |  |
| deployment.nameOverride | string | `""` |  |
| deployment.podAnnotations | object | `{}` |  |
| deployment.podSecurityContext.fsGroup | int | `10001` | fsGroup is defined at container build time and in most circumstances should not be changed |
| deployment.replicaCount | int | `1` | number of replicas to deploy |
| deployment.resources | object | `{}` | Pod resources request and limits |
| deployment.securityContext.capabilities | object | `{"drop":["ALL"]}` | Linux Capabilities for the container |
| deployment.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| deployment.securityContext.runAsNonRoot | bool | `true` |  |
| deployment.securityContext.runAsUser | int | `10001` | runAsUser is defined at container build time and in most circumstances should not be changed |
| deployment.ttlSecondsAfterFinished | int | `60` | length of time to retain job |
| domain.altNames | list | `["127.0.0.1"]` | alt names to add to the generated x509 cert |
| global.customRedirectPort | string | `nil` | customRedirectPort the port the API and Frontend services are listening on. Leave as null if using standard ports. ie 80 or 443. |
| global.gcpbackendConfig.config | object | `{}` |  |
| global.gcpbackendConfig.enabled | bool | `false` |  |
| global.gcpbackendConfig.loadbalancerAccessType | string | `"External"` |  |
| global.placeDomain | string | `nil` | placeDomain the initial PlaceOS domain. No default value, Must be set |
| podPriorities.highClassName | string | `"high"` | name for the the podPriority class used by 1st priority PalceOS containers |
| podPriorities.mediumClassName | string | `"medium"` | name for the the podPriority class used by 2nd priority PalceOS containers |
| runJob | bool | `true` | runJob deploys the default init job if set to true |
| secrets.PLACE_PASSWORD | string | `nil` |  |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
