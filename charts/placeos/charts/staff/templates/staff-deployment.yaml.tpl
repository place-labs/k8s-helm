apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "staff.fullname" . }}
  labels:
    {{- include "staff.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicaCount | default (ternary 3 1 (eq (.Values.global.env | default "") "prod")) }}
  selector:
    matchLabels:
      {{- include "staff.selectorLabels" . | nindent 6 }}
  template:
    metadata:
    {{- with .Values.deployment.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "staff.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "staff.serviceAccountName" . }}
      securityContext:
          {{- toYaml .Values.deployment.podSecurityContext | nindent 8 }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.deployment.securityContext | nindent 12 }}
        envFrom:
          - configMapRef:
              name:  {{ include "staff.fullname" . }}
          - secretRef:
              name: {{ include "staff.fullname" . }}
        image: "{{ .Values.deployment.image.registry }}/{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
        ports:
          - name: http
            containerPort: 8080
            protocol: TCP
        livenessProbe:
          httpGet:
            path: /api/staff/v1
            port: 8080
          timeoutSeconds: 10
          initialDelaySeconds: 10
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /api/staff/v1
            port: 8080
        resources:
          {{- toYaml .Values.deployment.resources | nindent 12 }}
      {{- if .Values.deployment.podPriorityClassName }}
      priorityClassName: {{ .Values.deployment.podPriorityClassName }}
      {{ end }}
      {{- with .Values.deployment.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.deployment.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.deployment.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      restartPolicy: Always
