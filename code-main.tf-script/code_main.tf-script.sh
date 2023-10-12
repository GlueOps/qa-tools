#!/bin/bash

read -p "Enter the name of development-captains repo (test-80-np or test-82-np) " value

cd /workspaces/glueops/$value.pluto.onglueops.rocks

source $(pwd)/.env

cd /workspaces/glueops/$value.pluto.onglueops.rocks/terraform/kubernetes

render_templates() {
  local template_dir="$1"
  local target_dir="$PWD"

  # Prompt the user for the value of the variable
  read -p "Enter arn:aws:iam number " value2

  # Create the target directory if it doesn't exist
  mkdir -p "$target_dir"

  # Loop through the template files in the template directory
  for template_file in "$template_dir"/*; do
    if [ -f "$template_file" ]; then
      # Extract the filename without the path
      template_filename=$(basename "$template_file")

      # Replace the placeholder with the user-entered value and save it to the target directory
      sed "s/1234567890/$value2/g" "$template_file" > "$target_dir/$template_filename"
    fi
  done

  echo "main.tf is successfully created in $target_dir."
}

# Call the function with the template and target directories
render_templates "../../../qa-tools/code-main.tf-script/templates" 

cd /workspaces/glueops/$value.pluto.onglueops.rocks

source .env

cd terraform/kubernetes/
