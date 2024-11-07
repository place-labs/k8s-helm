apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ include "core.fullname" . }}
  labels:
    core: {{ include "core.fullname" . }}
    {{- include "core.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicaCount }}
  selector:
    matchLabels:
      core: {{ include "core.fullname" . }}
      {{- include "core.selectorLabels" . | nindent 6 }}
  updateStrategy:
    type: RollingUpdate
  podManagementPolicy: Parallel
  serviceName: {{ include "core.fullname" . }}
  template:
    metadata:
    {{- with .Values.deployment.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        core: {{ include "core.fullname" . }}
        {{- include "core.labels" . | nindent 8 }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "core.serviceAccountName" . }}
      securityContext:
          {{- toYaml .Values.deployment.podSecurityContext | nindent 8 }}
      affinity:
        {{- toYaml .Values.deployment.affinity | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.deployment.terminationGracePeriodSeconds }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.deployment.securityContext | nindent 12 }}
        envFrom:
          - configMapRef:
              name:  {{ include "core.fullname" . }}
          - secretRef:
              name: {{ include "core.fullname" . }}
        env:
          - name: POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: POD_NAMESPACE
            valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
          - name: CORE_HOST
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
        image: "{{ .Values.deployment.image.registry }}/{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
        ports:
          - name: http
            containerPort: 3000
            protocol: TCP
        livenessProbe:
          httpGet:
            path: /api/core/v1
            port: http
          initialDelaySeconds: 30
        readinessProbe:
          httpGet:
            path: /api/core/v1
            port: http
          initialDelaySeconds: 30
          periodSeconds: 15
          failureThreshold: 10
        resources:
          {{- toYaml .Values.deployment.resources | nindent 12 }}
        volumeMounts:
        - mountPath: /app/bin/drivers/
          name: {{ include "core.fullname" . }}
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
  volumeClaimTemplates:
  - metadata:
      name: {{ include "core.fullname" . }}
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
