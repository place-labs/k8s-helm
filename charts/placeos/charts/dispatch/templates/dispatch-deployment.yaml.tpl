apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "dispatch.fullname" . }}
  labels:
    {{- include "dispatch.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicaCount }}
  selector:
    matchLabels:
      {{- include "dispatch.selectorLabels" . | nindent 6 }}
  template:
    metadata:
    {{- with .Values.deployment.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "dispatch.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "dispatch.serviceAccountName" . }}
      securityContext:
          {{- toYaml .Values.deployment.podSecurityContext | nindent 8 }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.deployment.securityContext | nindent 12 }}
        envFrom:
          - secretRef:
              name: {{ include "dispatch.fullname" . }}
        image: "{{ .Values.deployment.image.registry }}/{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
        ports:
          - name: http
            containerPort: 8080
            protocol: TCP
        {{- range $_ , $value := .Values.udpLoadbalancer.portMappings }}
        {{- range $lbPort, $podPort := $value }}
          - name: udp-{{ $podPort }}
            containerPort: {{ $podPort }}
            protocol: UDP
        {{- end }}
        {{- end }}
        {{- range $_ , $value := .Values.tcpLoadbalancer.portMappings }}
        {{- range $lbPort, $podPort := $value }}
          - name: tcp-{{ $podPort }}
            containerPort: {{ $podPort }}
            protocol: TCP
        {{- end }}
        {{- end }}
        {{/*
        livenessProbe:
          httpGet:
            path: /?liveness
            port: http
        readinessProbe:
          httpGet:
            path: /?readiness
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
