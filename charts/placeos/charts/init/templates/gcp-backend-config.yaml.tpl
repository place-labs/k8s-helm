{{- if .Values.global.gcpbackendConfig.enabled -}}
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: {{ .Values.global.gcpbackendConfig.name }}
spec:
  {{- toYaml .Values.global.gcpbackendConfig.config | nindent 2 }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.global.gcpbackendConfig.name }}
  annotations:
    cloud.google.com/load-balancer-type: {{ .Values.global.gcpbackendConfig.loadbalancerAccessType }}
    ingress.kubernetes.io/ssl-redirect: "true"
    kubernetes.io/ingress.class: "gce"
    kubernetes.io/ingress.global-static-ip-name: {{ .Values.global.gcpbackendConfig.global_static_ip_name }}
spec:
  tls:
  - secretName: {{ .Values.global.placeDomain }}
  rules:
  - host: 
    http:
      paths:
      - path: /*
        backend:
          service:
            name: frontend-loader-http-gcp
            port:
              number: 8080
      - path: /api/*
        backend:
          service:
            name: api-gcp
            port:
              number: 3000
      - path: /auth/*
        backend:
          service:
            name: auth-gcp
            port:
              number: 3000
      - path: /api/files/*
        backend:
          service:
            name: auth-gcp
            port:
              number: 3000
      - path: /api/staff/*
        backend:
          service:
            name: staff-gcp
            port:
              number: 8080
{{- end }}
