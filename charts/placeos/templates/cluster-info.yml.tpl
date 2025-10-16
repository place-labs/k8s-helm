# configmap cluster-info with environment, name, region, version
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-info
  labels:
    app.kubernetes.io/name: cluster-info
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/version: {{ .Chart.AppVersion }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
data:
  environment: {{ .Values.cluster_info.environment | default "development" }}
  name: {{ .Values.cluster_info.name | default "default" }}
  region: {{ .Values.cluster_info.region | default "default" }}
  version: {{ .Chart.AppVersion }}