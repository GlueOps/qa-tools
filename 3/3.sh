#!/bin/bash

source /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks/.env

kubectl -n glueops-core-vault port-forward svc/vault-ui 8200:8200 &

sleep 5  

cd /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks/terraform/vault/configuration/

terraform init && terraform apply -auto-approve

exit
