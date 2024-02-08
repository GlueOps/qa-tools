#!/bin/bash

read -p "Enter your captain domain: " CLUSTER

cd /workspaces/glueops/$CLUSTER/manifests

# Function to render templates
render_templates() {
  local template_dir="$1"
  local target_dir="$PWD"
  
  # Split cluster name to different parts

  IFS='.' read -r ENV TENANT DOMAIN <<< "$CLUSTER"

  unset process_webacl
  
  until [ "$process_webacl" == "yes" ] || [ "$process_webacl" == "no" ]; do
    # Webacl manifest creating
    read -p "Do you want to create webacl.yaml manifest? Type 'yes' or 'no': " process_webacl

    # Checking of input
    if [ "$process_webacl" != "yes" ] && [ "$process_webacl" != "no" ]; then
      echo "Invalid input. Please enter 'yes' or 'no'."
    fi
  done

  # Define webacl manifest fullname
  WEBACL="webacl.yaml"

  if [ "$process_webacl" == no ]; then
  echo "File processing skipped for $WEBACL."
  fi

  unset process_file

  until [ "$process_file" == "yes" ] || [ "$process_file" == "no" ]; do
    # Ecrregcred manifest creating
    read -p "Do you want to create ecr-regcred.yaml manifest? Type 'yes' or 'no': " process_file

    # Checking of input
    if [ "$process_file" != "yes" ] && [ "$process_file" != "no" ]; then
      echo "Invalid input. Please enter 'yes' or 'no'."
    fi
  done

  # Define ecrregcred manifest fullname
  REGCRED="ecr-regcred.yaml"

  if [ "$process_file" == no ]; then
    echo "File processing skipped for $REGCRED."
  else
    read -p "Enter access-key-id for ecr-regcred: " value2
    read -p "Enter secret-access-key: " value3
  fi

  unset use_defaultorg
  unset use_defaultrepo
  
  until [ "$use_defaultorg" == "yes" ] || [ "$use_defaultorg" == "no" ]; do
    # Organization path
    read -p "Do you use default organization(example-tenant)? Type 'yes' or 'no': " use_defaultorg

    # Checking of input
    if [ "$use_defaultorg" != "yes" ] && [ "$use_defaultorg" != "no" ]; then
      echo "Invalid input. Please enter 'yes' or 'no'."
    fi
  done
  
  if [ "$use_defaultorg" == yes ]; then
    org_name="example-tenant"
  else
    read -p "Enter organization name: " org_name
  fi

  until [ "$use_defaultrepo" == "yes" ] || [ "$use_defaultrepo" == "no" ]; do
    # Repository path
    read -p "Do you use default repository (deployment-configurations)? Type 'yes' or 'no': " use_defaultrepo

    # Checking of input
    if [ "$use_defaultrepo" != "yes" ] && [ "$use_defaultrepo" != "no" ]; then
      echo "Invalid input. Please enter 'yes' or 'no'."
    fi
  done

  if [ "$use_defaultrepo" == yes ]; then
    repo_name="deployment-configurations"
  else
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
      if  [ "$process_file" == yes ] || [ "$template_filename" != "$REGCRED" ]; then
        if [ "$process_webacl" == yes ] || [ "$template_filename" != "$WEBACL" ]; then
        sed "s/cluster_env/$ENV/g; s/CLUSTER_VARIABLE/$CLUSTER/g; s/key_id/$value2/g; s/key_value/$value3/g; s/example-tenant/$org_name/g; s/deployment-configurations/$repo_name/g" "$template_file" > "$target_dir/$template_filename"
        fi
      fi
    fi
  done

  echo "Templates have been rendered and saved to $target_dir."
}

# Call the function with the template and target directories
render_templates "../../qa-tools/manifests-ecr-protected-script/templates" 
