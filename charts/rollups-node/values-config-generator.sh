#!/usr/bin/env bash
# Script to convert values from rollups node TOML file to helm chart values YAML file with descriptions
set -euo pipefail
[[ -n ${DEBUG:-} ]] && set -x

VALUES_FILE="values.yaml"

# Process TOML file using yq and transform to YAML format
echo "Processing Config.toml using yq and transforming it to YAML format..."

cat "$VALUES_FILE".tpl > "$VALUES_FILE"

ROLLUPS_NODE_VERSION="$(yq .global.image.tag "$VALUES_FILE.tpl")"

# Convert TOML to YAML format and structure, keeping descriptions
curl -fsSL https://raw.githubusercontent.com/cartesi/rollups-node/v${ROLLUPS_NODE_VERSION}/internal/node/config/generate/Config.toml \
| yq -ptoml -oy '
{"validator": { "config":  (
.[] as $entry ireduce   ({};
    . * $entry
)
| to_entries
| with(.[];
    .key headComment = "-- " + .value.description
    | .value = .value.default // ""
)
| from_entries
) }}
' \
| sed '/^validator:/d;/^$/d' >> "$VALUES_FILE"

echo "Done."
