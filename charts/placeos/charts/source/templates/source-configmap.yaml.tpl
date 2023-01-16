apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "source.fullname" . }}
  labels:
    {{- include "source.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": "pre-install"
    "helm.sh/hook-delete-policy": "before-hook-creation"
data:
  {{- range $key, $val := .Values.configmap }}
  {{ $key }}: {{ $val | quote }}
  {{- end }}
