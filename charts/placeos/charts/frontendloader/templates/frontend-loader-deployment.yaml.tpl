apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ include "frontend-loader.fullname" . }}
  labels:
    {{- include "frontend-loader.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicaCount }}
  selector:
    matchLabels:
      {{- include "frontend-loader.selectorLabels" . | nindent 6 }}
  updateStrategy:
    type: RollingUpdate
  podManagementPolicy: Parallel
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
      affinity:
        {{- toYaml .Values.deployment.affinity | nindent 8 }}
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
          name: {{ .Values.persistentVolumeClaim.name }}
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
          name: {{ .Values.persistentVolumeClaim.name }}
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
      {{- with .Values.deployment.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      restartPolicy: Always
      volumes:
      - name: default-conf
        configMap:
          name: {{ include "frontend-loader.fullname" . }}-nginx-conf
  volumeClaimTemplates:
  - metadata:
      name: {{ .Values.persistentVolumeClaim.name }}
      annotations:
        pv.beta.kubernetes.io/gid: {{ .Values.deployment.podSecurityContext.fsGroup | quote }}
    spec:
      accessModes:
        {{- toYaml .Values.persistentVolumeClaim.accessModes | nindent 8 }}
      resources:
        requests:
          storage: {{ .Values.persistentVolumeClaim.storage | quote }}
      {{- if .Values.persistentVolumeClaim.storageClassName }}
      storageClassName: {{ .Values.persistentVolumeClaim.storageClassName }}
      {{- end }}