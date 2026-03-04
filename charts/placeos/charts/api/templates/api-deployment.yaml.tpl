apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "api.fullname" . }}
  labels:
    {{- include "api.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicaCount | default (ternary 2 1 (eq (.Values.global.env | default "") "prod")) }}
  selector:
    matchLabels:
      {{- include "api.selectorLabels" . | nindent 6 }}
  template:
    metadata:
    {{- with .Values.deployment.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "api.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "api.serviceAccountName" . }}
      securityContext:
          {{- toYaml .Values.deployment.podSecurityContext | nindent 8 }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.deployment.securityContext | nindent 12 }}
        envFrom:
          - configMapRef:
              name:  {{ include "api.fullname" . }}
          - secretRef:
              name: {{ include "api.fullname" . }}
        image: "{{ .Values.deployment.image.registry }}/{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
        ports:
          - name: http
            containerPort: 3000
            protocol: TCP
        volumeMounts:
        - mountPath: /tmp
          name: tmp
        livenessProbe:
          httpGet:
            path: /api/engine/v2/?liveness
            port: http
        readinessProbe:
          httpGet:
            path: /api/engine/v2/?readiness
            port: http
        resources:
        {{- if .Values.deployment.resources }}
          {{- toYaml .Values.deployment.resources | nindent 12 }}
        {{- else if eq (.Values.global.env | default "") "prod" }}
          limits:
            cpu: 1
            memory: 1Gi
          requests:
            cpu: 50m
            memory: 512Mi
        {{- else }}
          limits:
            cpu: 1
            memory: 512Mi
          requests:
            cpu: 10m
            memory: 96Mi
        {{- end }}
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
      - name: tmp
        emptyDir: {}
