{{ if .Values.alerting.enabled }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: placeos-grafana-alerting
  namespace: placeos-metrics
  labels:
    app.kubernetes.io/component: grafana
    app.kubernetes.io/instance: metrics
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: grafana
    helm.sh/chart: grafana-8.2.33
  annotations:
    meta.helm.sh/release-name: metrics
    meta.helm.sh/release-namespace: placeos-metrics
type: Opaque
data:
{{- range $path, $bytes := .Files.Glob "grafana-provisioning/alerting/*" }}
  {{ base $path }}: |-
{{ $.Files.Get $path | indent 4 }}
{{- end }}
  contact-points.yaml: |-
{{ .Files.Get "grafana-provisioning/alerting/contact-points.yaml" | replace "<metrics-webhook-url>" .Values.alerting.webhooks.metrics | replace "<placeos-webhook-url>" .Values.alerting.webhooks.placeos | indent 4 }}
{{ end }}
