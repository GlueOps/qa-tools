#!/bin/bash

read -p "Enter glueops-platform version: " value1

sleep 15

helm upgrade glueops-platform glueops-platform/glueops-platform --version $value1 -f platform.yaml --namespace=glueops-core
