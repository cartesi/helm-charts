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
cartesi.io/rollups-version: {{ .Values.cartesi.rollupsVersion }}
{{ include "validator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
TODO: diff between query and validator
*/}}
{{- define "validator.selectorLabels" -}}
dapp.cartesi.io/contract-address: {{ required "A valid .Values.dapp.contractAddress is required" .Values.dapp.contractAddress | quote }}
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
{{ include "images.image" ( dict "imageRoot" .Values.path.to.the.image ) }}
*/}}
{{- define "images.image" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $tag := .imageRoot.tag | toString -}}
{{- if $registryName }}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- else -}}
{{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper dispatcher image name
*/}}
{{- define "dispatcher.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.validator.dispatcher.image) }}
{{- end -}}

{{/*
Return the proper stateServer image name
*/}}
{{- define "stateServer.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.validator.stateServer.image) }}
{{- end -}}

{{/*
Return the proper indexer image name
*/}}
{{- define "indexer.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.validator.indexer.image) }}
{{- end -}}

{{/*
Return the proper indexer image name
*/}}
{{- define "queryServer.image" -}}
{{ include "images.image" (dict "imageRoot" .Values.queryServer.image) }}
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
{{- $networkIDs := dict "mainnet" "1" "ropsten" "2" "rinkeby" "4" "goerli" "5" "kovan" "42" "bsc_testnet" "57" "avax_fuji" "43113" "polygon_mumbai" "80001" "local" "1337" -}}
{{- get $networkIDs (required "A valid .Values.dapp.network is required" .Values.dapp.network) -}}
{{- end -}}
