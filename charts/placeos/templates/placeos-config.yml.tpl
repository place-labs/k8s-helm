# configmap placeos for config shared across all placeos services
apiVersion: v1
kind: ConfigMap
metadata:
  name: placeos
  labels:
    app.kubernetes.io/name: placeos
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/version: {{ .Chart.AppVersion }}
    app.kubernetes.io/managed-by: {{ .Release.Name }}
data:
  PLACE_LOG_FORMAT: {{ .Values.placeos_config.log_format | default "JSON" }}