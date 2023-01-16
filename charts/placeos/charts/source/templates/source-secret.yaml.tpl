kind: Secret
apiVersion: v1
metadata:
  name: {{ include "source.fullname" . }}
  labels:
    {{- include "source.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": "pre-install"
    "helm.sh/hook-delete-policy": "before-hook-creation"
stringData:
  {{- toYaml .Values.secrets | nindent 2 }}
