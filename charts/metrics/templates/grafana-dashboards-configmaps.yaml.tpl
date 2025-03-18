{{- range $filepath, $filebytes := .Files.Glob "grafana-provisioning/dashboards/**.json" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: placeos-grafana-dashboards-{{ $filepath | toString | splitList "/" | last | splitList "." | first }}
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
{{ $filepath | toString | splitList "/" | last | indent 2 }}: |-
{{ $.Files.Get $filepath | toString | indent 4 }}

---

{{- end }}