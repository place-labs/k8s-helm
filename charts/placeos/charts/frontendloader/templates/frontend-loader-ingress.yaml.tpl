{{- if .Values.ingress.enabled -}}
{{- $fullName := include "frontend-loader.fullname" . -}}
{{- $svcPort := .Values.httpservice.port -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1beta1
{{- else -}}
apiVersion: extensions/v1beta1
{{- end }}
kind: Ingress
metadata:
  name: {{ $fullName }}
  labels:
    {{- include "frontend-loader.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.ingress.tls }}
  tls:
    {{- range .Values.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ $.Values.global.placeDomain | quote }}
        {{- end }}
      secretName: {{ $.Values.global.placeDomain }}
    {{- end }}
  {{- end }}
  rules:
    {{- range .Values.ingress.hosts }}
    - host: {{ $.Values.global.placeDomain | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ . }}
            backend:
              serviceName: {{ $fullName }}-http
              servicePort: {{ $svcPort }}
          {{- end }}
    {{- end }}
  {{- end }}