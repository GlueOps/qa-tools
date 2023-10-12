#!/bin/bash

read -p "Enter the name of development-captains repo (test-80-np or test-82-np) " value

gh repo clone development-captains/$value.pluto.onglueops.rocks

gh repo clone example-tenant/deployment-configurations

cd deployment-configurations

git pull

cd ..