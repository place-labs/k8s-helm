apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "auth.fullname" . }}
  labels:
    {{- include "auth.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": "pre-install"
    "helm.sh/hook-delete-policy": "before-hook-creation"
data:
  PLACE_URI: https://{{ .Values.global.placeDomain  }}
  {{- range $key, $val := .Values.configmap }}
  {{ $key }}: {{ $val | quote }}
  {{- end }}
