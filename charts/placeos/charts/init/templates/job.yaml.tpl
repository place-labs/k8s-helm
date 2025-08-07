{{ if .Values.runJob -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "init.fullname" . }}
  labels:
    {{- include "init.labels" . | nindent 4 }}
  annotations:
    helm.sh/hook: "post-install"
    helm.sh/hook-delete-policy: "hook-succeeded,before-hook-creation"
spec:
  {{- if .Values.deployment.ttlSecondsAfterFinished }}
  ttlSecondsAfterFinished: {{ .Values.deployment.ttlSecondsAfterFinished }}
  {{ end }}
  template:
    metadata:
      {{- with .Values.deployment.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "init.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "init.serviceAccountName" . }}
      securityContext:
        {{- toYaml .Values.deployment.podSecurityContext | nindent 8 }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.deployment.securityContext | nindent 12 }}
          image: "{{ .Values.deployment.image.registry }}/{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
          env:
          {{- range $name, $val := .Values.config }}
            - name: {{ $name | quote }}
              value: {{ $val | quote }}
          {{- end }}
            - name: PLACE_DOMAIN
              value: {{ include "init.redirectURI" . }}
          envFrom:
          - secretRef:
              name:  {{ include "init.fullname" . }}
          resources:
            {{- toYaml .Values.deployment.resources | nindent 12 }}
      restartPolicy: OnFailure
  backoffLimit: 10
{{- end }}
