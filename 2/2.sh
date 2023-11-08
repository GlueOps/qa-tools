#!/bin/bash

# 1st piece

# curl https://raw.githubusercontent.com/GlueOps/terraform-module-cloud-aws-kubernetes-cluster/main/tests/main.tf -o qa-tools/2/templates/main.tf 

# cd /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks

# source $(pwd)/.env

# cd /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks/terraform/kubernetes

read -p "Enter arn:aws:iam number" value2

# render_templates() {
#   local template_dir="$1"
#   local target_dir="$PWD"

#   # Create the target directory if it doesn't exist
#   mkdir -p "$target_dir"

#   # Loop through the template files in the template directory
#   for template_file in "$template_dir"/*; do
#     if [ -f "$template_file" ]; then
#       # Extract the filename without the path
#       template_filename=$(basename "$template_file")

#       # Replace the placeholder with the user-entered value and save it to the target directory
#       sed -e "s/761182885829/$value2/g" -e "s/\.\.\//git::https:\/\/github.com\/GlueOps\/terraform-module-cloud-aws-kubernetes-cluster.git/g" "$template_file" > "$target_dir/$template_filename"
#     fi
#   done

#   echo "main.tf is successfully created in $target_dir."
# }

# # Call the function with the template and target directories
# render_templates "../../../qa-tools/2/templates" 

# cd /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks

# source .env

# cd terraform/kubernetes/

# # 2nd piece

# terraform init

# terraform apply -auto-approve

cd /workspaces/glueops

aws eks update-kubeconfig --region us-west-2 --name captain-cluster --role-arn arn:aws:iam::$value2:role/glueops-captain-role

sed -i 's/^#//' $CLUSTER.pluto.onglueops.rocks/.env

source /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks/.env

kubectl get nodes

kubectl delete daemonset -n kube-system aws-node

cd /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks

curl https://raw.githubusercontent.com/wiki/GlueOps/terraform-module-cloud-aws-kubernetes-cluster/calico.yaml.md -o ../qa-tools/2/templates2/calico.yaml 

# render_templates2() {
#   local template_dir="$1"
#   local target_dir="$PWD"

#   # Create the target directory if it doesn't exist
#   mkdir -p "$target_dir"

#   # Loop through the template files in the template directory
#   for template_file in "$template_dir"/*; do
#     if [ -f "$template_file" ]; then
#       # Extract the filename without the path
#       template_filename=$(basename "$template_file")

#       # Delete yaml markers
#       sed '/```yaml/,/```/d' "$template_file" > "$target_dir/$template_filename"
#     fi
#   done

#   echo "calico.yaml is successfully created in $target_dir."
# }

# render_templates2 "../../../qa-tools/2/templates2" 

# raw_link="https://raw.githubusercontent.com/wiki/GlueOps/terraform-module-cloud-aws-kubernetes-cluster/install-calico.md"

# commands=$(curl -s "$raw_link")

# commands=$(echo "$commands" | sed '/```bash/,/```/d') 

# echo=$commands

# bash -c "$commands"

# sed -i 's/^#//' /terraform/kubernetes/main.tf

# cd /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks/terraform/kubernetes

# terraform init

# terraform apply -auto-approve

# cd /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks
