apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "auth.fullname" . }}
  labels:
    {{- include "auth.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicaCount }}
  selector:
    matchLabels:
      {{- include "auth.selectorLabels" . | nindent 6 }}
  template:
    metadata:
    {{- with .Values.deployment.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "auth.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "auth.serviceAccountName" . }}
      securityContext:
          {{- toYaml .Values.deployment.podSecurityContext | nindent 8 }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.deployment.securityContext | nindent 12 }}
        env:
          - name: PLACE_URI
            value: {{ include "auth.placeURI" . }}
        envFrom:
          - configMapRef:
              name:  {{ include "auth.fullname" . }}
          - secretRef:
              name: {{ include "auth.fullname" . }}
        image: "{{ .Values.deployment.image.registry }}/{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
        ports:
          - name: http
            containerPort: 8080
            protocol: TCP
        {{/* 
        livenessProbe:
          httpGet:
            path: /auth/authority?health=true
            port: http
        readinessProbe:
          httpGet:
            path: /auth/authority?health=true
            port: http 
        */}}
        resources:
          {{- toYaml .Values.deployment.resources | nindent 12 }}
        volumeMounts:
        - mountPath: /app/tmp/
          name: app-tmp
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
      volumes:
      - name: app-tmp
        emptyDir: {}
