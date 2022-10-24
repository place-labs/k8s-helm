apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "frontend-loader.fullname" . }}
  labels:
    {{- include "frontend-loader.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicaCount }}
  selector:
    matchLabels:
      {{- include "frontend-loader.selectorLabels" . | nindent 6 }}
  strategy:
    type: Recreate
  template:
    metadata:
    {{- with .Values.deployment.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "frontend-loader.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "frontend-loader.serviceAccountName" . }}
      securityContext:
          {{- toYaml .Values.deployment.podSecurityContext | nindent 8 }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.deployment.securityContext | nindent 12 }}
        envFrom:
          - configMapRef:
              name:  {{ include "frontend-loader.fullname" . }}
          - secretRef:
              name: {{ include "frontend-loader.fullname" . }}
        image: "{{ .Values.deployment.image.registry }}/{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
        ports:
          - name: http
            containerPort: 3000
            protocol: TCP
        livenessProbe:
          httpGet:
            path: /api/frontend-loader/v1
            port: http
        readinessProbe:
          httpGet:
            path: /api/frontend-loader/v1
            port: http
        resources:
          {{- toYaml .Values.deployment.resources | nindent 12 }}
        volumeMounts:
        - mountPath: /app/www
          name: www
      {{- if .Values.httpSidecar }}
      - name: nginx
        image: nginx:1.18
        imagePullPolicy: ""
        {{/* securityContext:
          {{- toYaml .Values.deployment.securityContext | nindent 12 }} */}}
        ports:
        - containerPort: 8080
          name: http-nginx
        resources:
          {{- toYaml .Values.httpDeployment.resources | nindent 12 }}
        volumeMounts:
        - mountPath: /usr/share/nginx/html/
          name: www
          readOnly: true
        - mountPath: /etc/nginx/conf.d/
          name: default-conf
          readOnly: true
      {{- end }}
      {{- if .Values.deployment.podPriorityClassName }}
      priorityClassName: {{ .Values.deployment.podPriorityClassName }}
      {{- end }}
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
      - name: www
        persistentVolumeClaim:
          claimName: {{ .Values.persistentVolume.name }}
      - name: default-conf
        configMap:
          name: {{ include "frontend-loader.fullname" . }}-nginx-conf
