{{- if .Values.podDisruptionBudget.create }}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "api.fullname" . }}
  labels:
    {{- include "api.labels" . | nindent 4 }}
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ include "api.fullname" . }}
  maxUnavailable: 1
{{- end }}