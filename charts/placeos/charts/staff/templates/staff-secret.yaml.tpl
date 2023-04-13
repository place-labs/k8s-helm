kind: Secret
apiVersion: v1
metadata:
  name: {{ include "staff.fullname" . }}
  labels:
    {{- include "staff.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": "pre-install"
    "helm.sh/hook-delete-policy": "before-hook-creation"
stringData:
  {{- toYaml .Values.secrets | nindent 2 }}
