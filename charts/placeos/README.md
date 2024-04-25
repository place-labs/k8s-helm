# placeos

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

An Umbrella Chart for PlaceOS and its dependencies

## Requirements

| Repository | Name | Version |
|------------|------|---------|
|  | api | 0.1.0 |
|  | auth | 0.1.0 |
|  | core | 0.1.0 |
|  | dispatch | 0.1.0 |
|  | frontend-loader | 0.1.0 |
|  | init | 0.1.0 |
|  | search-ingest | 0.1.0 |
|  | triggers | 0.1.0 |
| https://charts.bitnami.com/bitnami | elasticsearch | ~12.6.3 |
| https://charts.bitnami.com/bitnami | influxdb | ~0.6.6 |
| https://charts.bitnami.com/bitnami | redis | ~10.8.2 |
| https://charts.helm.sh/stable/ | rethinkdb | ~1.1.2 |
| https://halkeye.github.io/helm-charts/ | mosquitto | ~0.2.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.configmap.<<.ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| api.configmap.<<.ES_HOST | string | `"elasticsearch-master"` | configmap value for ElasticSearch Service exposed as environment variables to PlaceOS containers |
| api.configmap.<<.ES_PORT | int | `9200` | configmap value for ElasticSearch Service exposed as environment variables to PlaceOS containers |
| api.configmap.<<.PLACE_LOADER_URI | string | `"http://frontend-loader:3000"` | configmap value for the frontend Service exposed as environment variables to PlaceOS containers |
| api.configmap.<<.REDIS_URL | string | `"redis://redis-headless:6379"` | configmap value for the redis Service exposed as environment variables to PlaceOS containers |
| api.configmap.<<.RETHINKDB_DB | string | `"place_development"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| api.configmap.<<.RETHINKDB_HOST | string | `"rethinkdb-proxy"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| api.configmap.<<.RETHINKDB_PORT | int | `28015` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| api.configmap.<<.RETHINKDB_USER | string | `"admin"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| api.configmap.<<.RUBBER_SOUL_URI | string | `"http://search-ingest:3000"` | configmap value for the Rubber Soul service exposed as environment variables to PlaceOS containers |
| api.configmap.<<.SG_ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| api.configmap.<<.TZ | string | `"Australia/Sydney"` | configmap value exposed as environment variables to PlaceOS containers |
| api.enabled | bool | `true` | api is a core PlaoceOS chart enabled by default. |
| api.fullnameOverride | string | `"api"` |  |
| api.secrets.<<.RETHINKDB_PASSWORD | string | `"password"` | secret value for the rethinkdb password exposed as environment variables to PlaceOS containers |
| auth.configmap.<<.RETHINKDB_DB | string | `"place_development"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| auth.configmap.<<.RETHINKDB_HOST | string | `"rethinkdb-proxy"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| auth.configmap.<<.RETHINKDB_PORT | int | `28015` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| auth.configmap.<<.RETHINKDB_USER | string | `"admin"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| auth.configmap.COAUTH_NO_SSL | string | `"true"` |  |
| auth.configmap.TZ | string | `"Australia/Sydney"` |  |
| auth.enabled | bool | `true` | auth is a core PlaoceOS chart enabled by default. |
| auth.fullnameOverride | string | `"auth"` |  |
| auth.secrets.<<.RETHINKDB_PASSWORD | string | `"password"` | secret value for the rethinkdb password exposed as environment variables to PlaceOS containers |
| core.configmap.<<.ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| core.configmap.<<.REDIS_URL | string | `"redis://redis-headless:6379"` | configmap value for the redis Service exposed as environment variables to PlaceOS containers |
| core.configmap.<<.RETHINKDB_DB | string | `"place_development"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| core.configmap.<<.RETHINKDB_HOST | string | `"rethinkdb-proxy"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| core.configmap.<<.RETHINKDB_PORT | int | `28015` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| core.configmap.<<.RETHINKDB_USER | string | `"admin"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| core.configmap.<<.SG_ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| core.configmap.<<.TZ | string | `"Australia/Sydney"` | configmap value exposed as environment variables to PlaceOS containers |
| core.enabled | bool | `true` | core is a core PlaoceOS chart enabled by default. |
| core.fullnameOverride | string | `"core"` |  |
| core.secrets.<<.RETHINKDB_PASSWORD | string | `"password"` | secret value for the rethinkdb password exposed as environment variables to PlaceOS containers |
| dispatch.enabled | bool | `true` | dispatch is a core PlaoceOS chart enabled by default. |
| dispatch.fullnameOverride | string | `"dispatch"` |  |
| dispatch.secrets.<<.SERVER_SECRET | string | `"development"` | secrets value exposed as environment variables for the dispatch service |
| elasticsearch.coordinating.replicas | int | `0` |  |
| elasticsearch.data.replicas | int | `1` |  |
| elasticsearch.enabled | bool | `false` | elasticsearch chart disabled by default. included for testing purposes only |
| elasticsearch.master.replicas | int | `1` |  |
| elasticsearch.templateOverrides.elasticsearchMasterfullName | string | `"elasticsearch-master"` | templateOverrides. A work around to override the full name of the ElasticSearch master. See templates/_helpers.tpl |
| frontend-loader.configmap.<<.ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| frontend-loader.configmap.<<.RETHINKDB_DB | string | `"place_development"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| frontend-loader.configmap.<<.RETHINKDB_HOST | string | `"rethinkdb-proxy"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| frontend-loader.configmap.<<.RETHINKDB_PORT | int | `28015` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| frontend-loader.configmap.<<.RETHINKDB_USER | string | `"admin"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| frontend-loader.configmap.<<.SG_ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| frontend-loader.configmap.<<.TZ | string | `"Australia/Sydney"` | configmap value exposed as environment variables to PlaceOS containers |
| frontend-loader.configmap.PLACE_LOADER_WWW | string | `"www"` | path to static html resources |
| frontend-loader.enabled | bool | `true` | frontend-loader is a core PlaoceOS chart enabled by default. |
| frontend-loader.fullnameOverride | string | `"frontend-loader"` |  |
| frontend-loader.httpSidecar | bool | `true` |  |
| frontend-loader.secrets.<<.RETHINKDB_PASSWORD | string | `"password"` | secret value for the rethinkdb password exposed as environment variables to PlaceOS containers |
| global.customRedirectPort | string | `nil` | customRedirectPort the port the API and Frontend services are listening on. Leave as null if using standard ports. ie 80 or 443. Used by the init service to configure the appropriate services |
| global.gcpbackendConfig.config | object | `{}` | yaml configuration for the BackendConfig |
| global.gcpbackendConfig.enabled | bool | `false` | gcpbackendConfig Create a GCP specific CustomResourceDefinition `BackendConfig` to enable a customisable L7 loabalancer instead of Nginx TCP loadbalancer See https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features |
| global.gcpbackendConfig.global_static_ip_name | string | `"l7-ip"` |  |
| global.gcpbackendConfig.loadbalancerAccessType | string | `"External"` | The type of load lalancer. External or Internal |
| global.gcpbackendConfig.name | string | `"placeos-core"` | the name of the BackendConfig Custom Resource |
| global.placeDomain | string | `nil` |  |
| influxdb.enabled | bool | `false` |  |
| influxdb.fullnameOverride | string | `"influxdb"` |  |
| init.config.<<.ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| init.config.<<.ES_HOST | string | `"elasticsearch-master"` | configmap value for ElasticSearch Service exposed as environment variables to PlaceOS containers |
| init.config.<<.ES_PORT | int | `9200` | configmap value for ElasticSearch Service exposed as environment variables to PlaceOS containers |
| init.config.<<.PLACE_APPLICATION | string | `"backoffice"` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| init.config.<<.PLACE_AUTH_HOST | string | `"auth:3000"` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| init.config.<<.PLACE_EMAIL | string | `"support@place.tech"` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| init.config.<<.PLACE_TLS | bool | `true` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| init.config.<<.PLACE_USERNAME | string | `"Place Support"` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| init.config.<<.RETHINKDB_DB | string | `"place_development"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| init.config.<<.RETHINKDB_HOST | string | `"rethinkdb-proxy"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| init.config.<<.RETHINKDB_PASSWORD | string | `"password"` | secret value for the rethinkdb password exposed as environment variables to PlaceOS containers |
| init.config.<<.RETHINKDB_PORT | int | `28015` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| init.config.<<.RETHINKDB_USER | string | `"admin"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| init.config.<<.SG_ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| init.config.<<.TZ | string | `"Australia/Sydney"` | configmap value exposed as environment variables to PlaceOS containers |
| init.enabled | bool | `true` | init is a core PlaoceOS chart enabled by default. |
| init.fullnameOverride | string | `"init"` |  |
| init.secrets.PLACE_PASSWORD | string | `"development"` | Default password for initial users in domain |
| mosquitto.enabled | bool | `false` | mosquitto chart disabled by default. included for testing purposes only |
| mosquitto.fullnameOverride | string | `"mosquitto"` |  |
| redis.cluster.enabled | bool | `false` |  |
| redis.configmap | string | `"notify-keyspace-events Kg$"` |  |
| redis.enabled | bool | `false` | redis chart disabled by default. included for testing purposes only |
| redis.fullnameOverride | string | `"redis"` |  |
| redis.usePassword | bool | `false` |  |
| rethinkdb.cluster.replicas | int | `1` |  |
| rethinkdb.enabled | bool | `false` | rethinkdb chart disabled by default. included for testing purposes only |
| rethinkdb.rethinkdbPassword | string | `"password"` |  |
| rethinkdb.templateOverrides.rethinkdbFullName | string | `"rethinkdb"` | templateOverrides. A work around to override the full name of the RethinkDb deployment. See templates/_helpers.tpl |
| search-ingest.configmap.<<.ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| search-ingest.configmap.<<.ES_HOST | string | `"elasticsearch-master"` | configmap value for ElasticSearch Service exposed as environment variables to PlaceOS containers |
| search-ingest.configmap.<<.ES_PORT | int | `9200` | configmap value for ElasticSearch Service exposed as environment variables to PlaceOS containers |
| search-ingest.configmap.<<.RETHINKDB_DB | string | `"place_development"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| search-ingest.configmap.<<.RETHINKDB_HOST | string | `"rethinkdb-proxy"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| search-ingest.configmap.<<.RETHINKDB_PORT | int | `28015` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| search-ingest.configmap.<<.RETHINKDB_USER | string | `"admin"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| search-ingest.configmap.<<.SG_ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| search-ingest.configmap.<<.TZ | string | `"Australia/Sydney"` | configmap value exposed as environment variables to PlaceOS containers |
| search-ingest.enabled | bool | `true` | search-ingest is a core PlaoceOS chart enabled by default. |
| search-ingest.fullnameOverride | string | `"search-ingest"` |  |
| search-ingest.secrets.<<.RETHINKDB_PASSWORD | string | `"password"` | secret value for the rethinkdb password exposed as environment variables to PlaceOS containers |
| triggers.configmap.<<.ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| triggers.configmap.<<.REDIS_URL | string | `"redis://redis-headless:6379"` | configmap value for the redis Service exposed as environment variables to PlaceOS containers |
| triggers.configmap.<<.RETHINKDB_DB | string | `"place_development"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| triggers.configmap.<<.RETHINKDB_HOST | string | `"rethinkdb-proxy"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| triggers.configmap.<<.RETHINKDB_PORT | int | `28015` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| triggers.configmap.<<.RETHINKDB_USER | string | `"admin"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| triggers.configmap.<<.SG_ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| triggers.configmap.<<.SMTP_PORT | int | `587` | configmap value for the SMTP server exposed as environment variables for the trigger service |
| triggers.configmap.<<.SMTP_SECURE | string | `""` | configmap value for the SMTP server exposed as environment variables for the trigger service |
| triggers.configmap.<<.SMTP_SERVER | string | `""` | configmap value for the SMTP server exposed as environment variables for the trigger service |
| triggers.configmap.<<.SMTP_USER | string | `""` | configmap value for the SMTP server exposed as environment variables for the trigger service |
| triggers.configmap.<<.TZ | string | `"Australia/Sydney"` | configmap value exposed as environment variables to PlaceOS containers |
| triggers.enabled | bool | `true` | triggers is a core PlaoceOS chart enabled by default. |
| triggers.fullnameOverride | string | `"triggers"` |  |
| triggers.secrets.<<.RETHINKDB_PASSWORD | string | `"password"` | secret value for the rethinkdb password exposed as environment variables to PlaceOS containers |
| triggers.secrets.<<.SMTP_PASS | string | `""` | secrets value exposed as environment variables for the trigger service |
| xdeploymentEnv.ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| xdeploymentEnv.SG_ENV | string | `"development"` | configmap value exposed as environment variables to PlaceOS containers |
| xdeploymentEnv.TZ | string | `"Australia/Sydney"` | configmap value exposed as environment variables to PlaceOS containers |
| xdispatchSecrets.SERVER_SECRET | string | `"development"` | secrets value exposed as environment variables for the dispatch service |
| xelasticClientEnv.ES_HOST | string | `"elasticsearch-master"` | configmap value for ElasticSearch Service exposed as environment variables to PlaceOS containers |
| xelasticClientEnv.ES_PORT | int | `9200` | configmap value for ElasticSearch Service exposed as environment variables to PlaceOS containers |
| xinitConfigEnv.PLACE_APPLICATION | string | `"backoffice"` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| xinitConfigEnv.PLACE_AUTH_HOST | string | `"auth:3000"` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| xinitConfigEnv.PLACE_EMAIL | string | `"support@place.tech"` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| xinitConfigEnv.PLACE_TLS | bool | `true` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| xinitConfigEnv.PLACE_USERNAME | string | `"Place Support"` | configmap value for the initialisation job exposed as environment variables for the init subchart |
| xplaceLoaderClientEnv.PLACE_LOADER_URI | string | `"http://frontend-loader:3000"` | configmap value for the frontend Service exposed as environment variables to PlaceOS containers |
| xplacePassword | string | `"development"` | yaml anchor . The value used by the init subchart to set the default domain users password |
| xredisClientEnv.REDIS_URL | string | `"redis://redis-headless:6379"` | configmap value for the redis Service exposed as environment variables to PlaceOS containers |
| xrethinkdbClientEnv.RETHINKDB_DB | string | `"place_development"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| xrethinkdbClientEnv.RETHINKDB_HOST | string | `"rethinkdb-proxy"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| xrethinkdbClientEnv.RETHINKDB_PORT | int | `28015` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| xrethinkdbClientEnv.RETHINKDB_USER | string | `"admin"` | configmap value for RethinkDB Service exposed as environment variables to PlaceOS containers |
| xrethinkdbClientSecrets.RETHINKDB_PASSWORD | string | `"password"` | secret value for the rethinkdb password exposed as environment variables to PlaceOS containers |
| xrethinkdbPassword | string | `"password"` | yaml anchor for the admin password for RethinkDb. Used to set the admin password in RethinkDB if enabled then passed to multiple containers in a k8s secret |
| xrubberSoulClientEnv.RUBBER_SOUL_URI | string | `"http://search-ingest:3000"` | configmap value for the Rubber Soul service exposed as environment variables to PlaceOS containers |
| xserverSecret | string | `"development"` | yaml anchor for the dispatch service |
| xsmtpClientEnv.SMTP_PORT | int | `587` | configmap value for the SMTP server exposed as environment variables for the trigger service |
| xsmtpClientEnv.SMTP_SECURE | string | `""` | configmap value for the SMTP server exposed as environment variables for the trigger service |
| xsmtpClientEnv.SMTP_SERVER | string | `""` | configmap value for the SMTP server exposed as environment variables for the trigger service |
| xsmtpClientEnv.SMTP_USER | string | `""` | configmap value for the SMTP server exposed as environment variables for the trigger service |
| xsmtpClientSecrets.SMTP_PASS | string | `""` | secrets value exposed as environment variables for the trigger service |
| xsmtpPassword | string | `""` | yaml anchor for the smtp password used by triggers |
| xtz | string | `"Australia/Sydney"` | yaml anchor the local time zone for the deployment |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
