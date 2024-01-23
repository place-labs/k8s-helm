apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "staff.fullname" . }}
  labels:
    {{- include "staff.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": "pre-install"
    "helm.sh/hook-delete-policy": "before-hook-creation"
data:
  PLACE_URI: http://api:3000
  {{- range $key, $val := .Values.configmap }}
  {{ $key }}: {{ $val | quote }}
  {{- end }}
