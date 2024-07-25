{{- if .Values.udpLoadbalancer.portMappings }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "dispatch.fullname" . }}-udp
  labels:
    {{- include "dispatch.labels" . | nindent 4 }}
  {{- with .Values.udpLoadbalancer.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  type: {{ .Values.udpLoadbalancer.type }}
  ports:
  {{- range $_ , $value := .Values.udpLoadbalancer.portMappings }}
  {{- range $lbPort, $podPort := $value }}
    - port: {{ $lbPort }}
      targetPort: udp-{{ $podPort }}
      protocol: UDP
      name: udp-{{ $lbPort }}
  {{- end }}
  {{- end }}
  externalTrafficPolicy: Local
  selector:
    {{- include "dispatch.selectorLabels" . | nindent 4 }}
{{ end }}
