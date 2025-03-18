{{- if not .Values.global.openshift }}
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: {{ .Values.podPriorities.highClassName }}
value: 1000000
globalDefault: false
description: "This priority class should be used for critical service pods"
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: {{ .Values.podPriorities.mediumClassName }}
value: 100000
globalDefault: false
description: "This priority class should be used for medium priority pods"
{{- end }}