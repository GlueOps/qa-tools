#!/bin/bash

cd ..

source /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks/.env

kubectl -n glueops-core-vault port-forward svc/vault-ui 8200:8200 &

sleep 15  

cd /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks/terraform/vault/configuration/

terraform init && terraform apply -auto-approve

pkill -f "kubectl -n glueops-core-vault port-forward"

