{{- define "hello-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hello-app.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "hello-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hello-app.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "hello-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "hello-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
