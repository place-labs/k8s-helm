apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "core.fullname" . }}
  labels:
    {{- include "core.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": "pre-install"
    "helm.sh/hook-delete-policy": "before-hook-creation"
data:
  {{- range $key, $val := .Values.configmap }}
  {{ $key }}: {{ $val | quote }}
  {{- end }}
