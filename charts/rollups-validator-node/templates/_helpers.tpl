{{- /*
(c) Cartesi and individual authors (see AUTHORS)
SPDX-License-Identifier: Apache-2.0 (see LICENSE)
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "validator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
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
dapp.cartesi.io/contract-address: {{ required "A valid .Values.dapp.contractAddress is required" .Values.dapp.contractAddress | lower | quote }}
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
Return the proper dispatcher image name
*/}}
{{- define "dispatcher.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.validator.dispatcher.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper stateServer image name
*/}}
{{- define "stateServer.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.validator.stateServer.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper indexer image name
*/}}
{{- define "indexer.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.validator.indexer.image "global" .Values.global ) }}
{{- end -}}

{{/*
Return the proper graphqlServer image name
*/}}
{{- define "graphqlServer.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.endpoints.graphqlServer.image "global" .Values.global ) }}
{{- end -}}

{{/*
Return the proper inspectServer image name
*/}}
{{- define "inspectServer.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.endpoints.inspectServer.image "global" .Values.global ) }}
{{- end -}}

{{/*
Return the proper serverManager.advanceRunner image name
*/}}
{{- define "serverManager.advanceRunner.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.serverManager.advanceRunner.image "global" .Values.global ) }}
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
{{- $networkIDs := dict "mainnet" "1" "goerli" "5" "bsc-testnet" "57" "avalanche-fuji" "43113" "polygon-mumbai" "80001" "optimism-goerli" "420" "arbitrum-goerli" "421613" "chiado" "10200" "localhost" "31337" "sepolia" "11155111" -}}
{{- get $networkIDs (required "A valid .Values.dapp.network is required" .Values.dapp.network) -}}
{{- end -}}
