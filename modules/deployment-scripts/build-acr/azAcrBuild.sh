#!/bin/bash
set -e

echo "Waiting on RBAC replication ($initialDelay)"
sleep $initialDelay

az acr build --resource-group $acrResourceGroup \
  --registry $acrName \
  --image $taggedImageName $repo \
  --file $dockerfilePath \
  --platform $platform