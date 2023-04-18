{{/*
Expand the name of the chart.
*/}}
{{- define "placeos.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "placeos.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "placeos.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "placeos.labels" -}}
helm.sh/parent-chart: {{ include "placeos.chart" . }}
{{ include "placeos.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/parent-version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "placeos.selectorLabels" -}}
app.kubernetes.io/parent-name: {{ include "placeos.name" . }}
app.kubernetes.io/parent-instance: {{ .Release.Name }}
{{- end }}

{{/*
dependent service name overrides.
This makes the service endpoint predictable as the actual charts do not cater for this
*/}}

{{- define "elasticsearch.master.fullname" -}}
{{- printf "%s" .Values.templateOverrides.elasticsearchMasterfullName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
