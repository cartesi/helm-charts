#!/usr/bin/env bash
# Script to convert values from rollups node TOML file to helm chart values YAML file with descriptions

set -euo pipefail

# Define file names
TOML_FILE="Config.toml"
TEMPLATE_VALUES_FILE="values.yaml.tpl"
VALUES_FILE="values.yaml"

# Download the Config.toml file from the rollups-node repository
echo "Downloading $TOML_FILE..."
wget https://raw.githubusercontent.com/cartesi/rollups-node/main/internal/config/generate/Config.toml

# Use the template TOML values file as a starting point
echo "Using $TEMPLATE_VALUES_FILE as the template values file..."
cat "$TEMPLATE_VALUES_FILE" > "$VALUES_FILE"

# Process TOML file using yq and transform to YAML format
echo "Processing $TOML_FILE using yq and transforming it to YAML format..."

# Convert TOML to YAML format and structure, keeping descriptions
cat $TOML_FILE \
| yq -ptoml -oy '
  .[]
  | to_entries
  | map
    (
      {
        .key: .value.default // "",
        "description": .value.description
      }
    )
  | .[] headComment |= "-- " + .description
  | del(.[].description)
  | .[]
' \
| yq '
  {
    "validator":
      {
        "config": .
      }
  }' \
| sed '/^validator:/d;/^$/d' >> "$VALUES_FILE"

echo "Script completed. Result saved to $VALUES_FILE."

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf "$TOML_FILE"

echo "Done."
