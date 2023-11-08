#!/bin/bash

cd /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks/terraform/vault/configuration/

terraform init

terraform apply -auto-approve