apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "rubber-soul.fullname" . }}
  labels:
    {{- include "rubber-soul.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicaCount }}
  selector:
    matchLabels:
      {{- include "rubber-soul.selectorLabels" . | nindent 6 }}
  template:
    metadata:
    {{- with .Values.deployment.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "rubber-soul.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "rubber-soul.serviceAccountName" . }}
      securityContext:
          {{- toYaml .Values.deployment.podSecurityContext | nindent 8 }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.deployment.securityContext | nindent 12 }}
        envFrom:
          - configMapRef:
              name:  {{ include "rubber-soul.fullname" . }}
        image: "{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
        ports:
          - name: http
            containerPort: 3000
            protocol: TCP
        {{/*
        livenessProbe:
          httpGet:
            path: /api/rubber-soul/v1
            port: http
        readinessProbe:
          httpGet:
            path: /api/rubber-soul/v1
            port: http
        */}}
        resources:
          {{- toYaml .Values.deployment.resources | nindent 12 }}
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