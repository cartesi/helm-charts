{{- /*
(c) Cartesi and individual authors (see AUTHORS)
SPDX-License-Identifier: Apache-2.0 (see LICENSE)
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "validator.name" -}}
{{- default (regexReplaceAll "(^.*)(-chart)$" .Chart.Name "${1}" ) .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "validator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default (include "validator.name" .) .Values.nameOverride }}
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
{{- define "validator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
TODO: diff between query and validator
*/}}
{{- define "validator.labels" -}}
helm.sh/chart: {{ include "validator.chart" . }}
cartesi.io/project: rollups
cartesi.io/rollups-version: {{ .Values.global.image.tag }}
{{ include "validator.selectorLabels" . }}
{{- if .Chart.Version }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
TODO: diff between query and validator
*/}}
{{- define "validator.selectorLabels" -}}
dapp.cartesi.io/contract-address: {{ required "A valid .Values.validator.config.CARTESI_CONTRACTS_DAPP_ADDRESS is required" .Values.validator.config.CARTESI_CONTRACTS_DAPP_ADDRESS | lower | quote }}
dapp.cartesi.io/chain-id: {{ include "dapp.chainID" . | quote }}
dapp.cartesi.io/network:  {{ .Values.dapp.network | quote }}
app.kubernetes.io/name: {{ include "validator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "validator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "validator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper image name
{{ include "images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "images.image" -}}
{{- $registryName := coalesce .imageRoot.registry .global.image.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $separator := ":" -}}
{{- $termination := coalesce .imageRoot.tag .global.image.tag | toString -}}
{{- if .imageRoot.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .imageRoot.digest | toString -}}
{{- end -}}
{{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- end -}}

{{/*
Return the proper validator image name
*/}}
{{- define "validator.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.validator.image "global" .Values.global) }}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Return the chainID based on the network
*/}}
{{- define "dapp.chainID" -}}
{{- $networkIDs := dict "mainnet" "1" "optimism" "10" "optimism-goerli" "420" "arbitrum" "42161" "arbitrum-goerli" "421613" "localhost" "31337" "sepolia" "11155111" -}}
{{- $chainID := index $networkIDs .Values.dapp.network }}
{{- $chainID }}
{{- end -}}
