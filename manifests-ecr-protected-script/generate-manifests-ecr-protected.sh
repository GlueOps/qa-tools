#!/bin/bash

read -p "Enter your cluster name: " CLUSTER

cd /workspaces/glueops/$CLUSTER/manifests

# Function to render templates
render_templates() {
  local template_dir="$1"
  local target_dir="$PWD"
  
  # Split cluster name to different parts

  IFS='.' read -r ENV TENANT DOMAIN <<< "$CLUSTER"

  # Dcrregcred manifest creating
  read -p "Do you want to create ecr-regcred.yaml manifest? Type 'yes' or 'no': " process_file

  # Define ecrregcred manifest fullname
  REGCRED="ecr-regcred.yaml"

  if [ "$process_file" == no ]; then
    echo "File processing skipped for $REGCRED."
  else
    read -p "Enter access-key-id for ecr-regcred: " value2
    read -p "Enter secret-access-key: " value3
  fi

  # Organization and repository path
  read -p "Do you use default organization(example-tenant) and repository(deployment-configurations)? Type 'yes' or 'no': " use_default
  
  if [ "$use_default" == yes ]; then
    org_name="example-tenant"
    repo_name="deployment-configurations"
  else
    read -p "Enter organization name: " org_name
    read -p "Enter repository name: " repo_name
  fi

  # Create the target directory if it doesn't exist
  mkdir -p "$target_dir"

  # Loop through the template files in the template directory
  for template_file in "$template_dir"/*; do
    if [ -f "$template_file" ]; then
      # Extract the filename without the path
      template_filename=$(basename "$template_file")

      # Replace the placeholder with the user-entered value and save it to the target directory
      if [ "$process_file" == yes ] || [ "$template_filename" != "$REGCRED" ]; then
        sed "s/cluster_env/$ENV/g; s/key_id/$value2/g; s/key_value/$value3/g; s/example-tenant/$org_name/g; s/deployment-configurations/$repo_name/g" "$template_file" > "$target_dir/$template_filename"
      fi
    fi
  done

  echo "Templates have been rendered and saved to $target_dir."
}

# Call the function with the template and target directories
render_templates "../../qa-tools/manifests-ecr-protected-script/templates" 
