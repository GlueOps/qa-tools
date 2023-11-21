#!/bin/bash

cd /workspaces/glueops/$CLUSTER/manifests

# Function to render templates
render_templates() {
  local template_dir="$1"
  local target_dir="$PWD"

  # Prompt the user for the value of the variables
  read -p "Enter placeholder value (test-80-np, test-82-np or test-1-np) " value

  read -p "Enter access-key-id for ecr-regcred: " value2

  read -p "Enter secret-access-key: " value3

  # Create the target directory if it doesn't exist
  mkdir -p "$target_dir"

  # Loop through the template files in the template directory
  for template_file in "$template_dir"/*; do
    if [ -f "$template_file" ]; then
      # Extract the filename without the path
      template_filename=$(basename "$template_file")

      # Replace the placeholder with the user-entered value and save it to the target directory
      sed "s/cluster_env/$value/g; s/key_id/$value2/g; s/key_value/$value3/g" "$template_file" > "$target_dir/$template_filename"
    fi
  done

  echo "Templates have been rendered and saved to $target_dir."
}

# Call the function with the template and target directories
render_templates "../../qa-tools/manifests-ecr-protected-script/templates" 
