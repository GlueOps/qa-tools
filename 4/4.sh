#!/bin/bash

git pull

cd ..

helm repo update

read -p "Enter ArgoCD version: " value1

read -p "Enter helm-chart version: " value2

kubectl apply -k "https://github.com/argoproj/argo-cd/manifests/crds?ref=value1"

helm diff upgrade argocd argo/argo-cd --version value2 -f argocd.yaml -n glueops-core

sleep 10

helm upgrade argocd argo/argo-cd --version value2 -f argocd.yaml -n glueops-core