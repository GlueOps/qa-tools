#!/bin/bash

gh repo clone development-captains/$CLUSTER.pluto.onglueops.rocks

gh repo clone example-tenant/deployment-configurations

cd deployment-configurations

git pull

cd ..