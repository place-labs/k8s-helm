{{- if not .Values.httpSidecar -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "frontend-loader.fullname" . }}-nginx
  labels:
    {{- include "frontend-loader.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.httpDeployment.replicaCount }}
  selector:
    matchLabels:
      {{- include "frontend-loader.selectorLabels" . | nindent 6 }}
      {{- if .Values.global.gcpbackendConfig.enabled }}
      placeos.backend/type: "gcp" 
      {{- end }}
  template:
    metadata:
    {{- with .Values.httpDeployment.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "frontend-loader.selectorLabels" . | nindent 8 }}
        {{- if .Values.global.gcpbackendConfig.enabled }}
        placeos.backend/type: "gcp" 
        {{- end }}
    spec:
      {{- with .Values.httpDeployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "frontend-loader.serviceAccountName" . }}
      securityContext:
          {{- toYaml .Values.httpDeployment.podSecurityContext | nindent 8 }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.httpDeployment.securityContext | nindent 12 }}
        image: "{{ .Values.httpDeployment.image.repository }}:{{ .Values.httpDeployment.image.tag }}"
        imagePullPolicy: "{{ .Values.httpDeployment.image.pullPolicy }}"
        ports:
        - containerPort: 8080
          name: http-nginx
        livenessProbe:
          httpGet:
            path: /login/
            port: 8080
          timeoutSeconds: 10
          initialDelaySeconds: 10
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /login/
            port: 8080
          timeoutSeconds: 10
          initialDelaySeconds: 10
          failureThreshold: 3
        resources:
          {{- toYaml .Values.httpDeployment.resources | nindent 12 }}
        volumeMounts:
        - mountPath: /usr/share/nginx/html/
          name: www
          readOnly: true
        - mountPath: /etc/nginx/conf.d/
          name: default-conf
          readOnly: true
        - mountPath: /var/cache/nginx
          name: cache
        - mountPath: /tmp
          name: tmp
      {{- if .Values.httpDeployment.podPriorityClassName }}
      priorityClassName: {{ .Values.httpDeployment.podPriorityClassName }}
      {{ end }}
      {{- with .Values.httpDeployment.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.httpDeployment.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.httpDeployment.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      restartPolicy: Always
      volumes:
      - name: cache
        emptyDir: {}
      - name: tmp
        emptyDir: {}
      - name: www
        persistentVolumeClaim:
          claimName: {{ .Values.persistentVolume.name }}
      - name: default-conf
        configMap:
          name: {{ include "frontend-loader.fullname" . }}-nginx-conf
{{- end -}}
