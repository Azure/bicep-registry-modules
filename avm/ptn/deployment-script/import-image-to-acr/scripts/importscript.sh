#!/bin/bash
set -e

echo 'Waiting on RBAC replication ($initialDelay)'
sleep $initialDelay

# retry loop to catch errors (usually RBAC delays, but 'Error copying blobs' is also not unheard of)
retryLoopCount=0
until [ $retryLoopCount -ge $retryMax ]
do
  echo 'Importing Image ($retryLoopCount): $imageName into ACR: $acrName'
  if [ $overwriteExistingImage = 'true' ]; then
    az acr import -n $acrName --source $imageName --force && break
  else
    az acr import -n $acrName --source $imageName && break
  fi

  sleep $retrySleep
  retryLoopCount=$((retryLoopCount+1))
done

echo 'done'
