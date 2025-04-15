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
{{ range $filename, $content := (.Files.Glob "grafana-provisioning/alerting/*") }}
  {{ $filename }}: {{ $content }}
{{ end }}
