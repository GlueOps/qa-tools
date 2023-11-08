#!/bin/bash

source /workspaces/glueops/$CLUSTER.pluto.onglueops.rocks/.env

kubectl -n glueops-core-vault port-forward svc/vault-ui 8200:8200