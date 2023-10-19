#!/bin/bash

read -p "Enter the name of development-captains repo (test-80-np or test-82-np) " value

cd /workspaces/glueops/$value.pluto.onglueops.rocks

render_templates() {
  local template_dir="$1"
  local target_dir="$PWD"

  # Create the target directory if it doesn't exist
  mkdir -p "$target_dir"

  # Loop through the template files in the template directory
  for template_file in "$template_dir"/*; do
    if [ -f "$template_file" ]; then
      # Extract the filename without the path
      template_filename=$(basename "$template_file")

      # Replace the placeholder with the user-entered value and save it to the target directory
      cat "$template_file" > "$target_dir/$template_filename"
    fi
  done

  echo "calico.yaml is successfully created in $target_dir."
}

# Call the function with the template and target directories
render_templates "../qa-tools/code-calico.yaml-script/templates" 

helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo update
helm install calico projectcalico/tigera-operator --version v3.26.1 --namespace tigera-operator -f calico.yaml --create-namespace

