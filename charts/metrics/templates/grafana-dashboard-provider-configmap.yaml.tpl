apiVersion: v1
kind: ConfigMap
metadata:
  name: placeos-grafana-dashboard-provider
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
data:
  default-provider.yaml: |-
    apiVersion: 1

    providers:
      # <string> an unique provider name
    - name: 'placeos-provider'
      # <int> org id. will default to orgId 1 if not specified
      orgId: 1
      # <string, required> name of the dashboard folder. Required
      folder: PlaceOS
      # <string> folder UID. will be automatically generated if not specified
      folderUid: ''
      # <string, required> provider type. Required
      type: file
      # <bool> disable dashboard deletion
      disableDeletion: false
      # <bool> enable dashboard editing
      editable: true
      # <int> how often Grafana will scan for changed dashboards
      updateIntervalSeconds: 10
      options:
        # <string, required> path to dashboard files on disk. Required
        path: /opt/bitnami/grafana/dashboards
        # <bool> enable folders creation for dashboards
        foldersFromFilesStructure: true