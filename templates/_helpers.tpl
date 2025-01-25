{{/*
Expand the name of the chart.
*/}}
{{- define "builkdite-agent-metrics-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "builkdite-agent-metrics-helm.fullname" -}}
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
{{- define "builkdite-agent-metrics-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "builkdite-agent-metrics-helm.labels" -}}
helm.sh/chart: {{ include "builkdite-agent-metrics-helm.chart" . }}
{{ include "builkdite-agent-metrics-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "builkdite-agent-metrics-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "builkdite-agent-metrics-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "builkdite-agent-metrics-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "builkdite-agent-metrics-helm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "buildkite-agent-metrics.args" -}}
{{- range $key, $value := .Values.config -}}
{{- if not (kindIs "map" $value) -}}
    {{- printf "- -%s=%s" ($key | kebabcase) $value  | nindent 2 -}}
{{- end -}}
{{ end }}

{{- if eq .Values.config.backend "cloudwatch" }}
{{- include "buildkite-agent-metrics.args.cloudwatch" . -}}
{{- end -}}

{{- if eq .Values.config.backend "prometheus" }}
{{- include "buildkite-agent-metrics.args.prometheus" . -}}
{{- end -}}

{{- if eq .Values.config.backend "statsd" }}
{{- include "buildkite-agent-metrics.args.statsd" . -}}
{{- end -}}

{{- if eq .Values.config.backend "newrelic" }}
{{- include "buildkite-agent-metrics.args.newrelic" . -}}
{{- end -}}

{{- if eq .Values.config.backend "stackdriver" }}
{{- include "buildkite-agent-metrics.args.stackdriver" . -}}
{{- end -}}

{{ end }}

{{- define "buildkite-agent-metrics.args.prometheus" -}}
{{ range $key, $value := .Values.config.prometheus }}
    {{- printf "- -%s=%s" ($key | kebabcase) $value  | nindent 2 -}}
{{ end }}
{{ end}}

{{- define "buildkite-agent-metrics.args.cloudwatch" -}}
{{ range $key, $value := .Values.config.cloudwatch }}
    {{- printf "- -%s=%s" ($key | kebabcase) $value  | nindent 2 -}}
{{ end }}
{{ end}}

{{- define "buildkite-agent-metrics.args.statsd" -}}
{{ range $key, $value := .Values.config.statsd }}
    {{- printf "- -%s=%s" ($key | kebabcase) $value  | nindent 2 -}}
{{ end }}
{{ end}}

{{- define "buildkite-agent-metrics.args.newrelic" -}}
{{ range $key, $value := .Values.config.newrelic }}
    {{- printf "- -%s=%s" ($key | kebabcase) $value  | nindent 2 -}}
{{ end }}
{{ end}}

{{- define "buildkite-agent-metrics.args.stackdriver" -}}
{{ range $key, $value := .Values.config.stackdriver }}
    {{- printf "- -%s=%s" ($key | kebabcase) $value  | nindent 2 -}}
{{ end }}
{{ end}}