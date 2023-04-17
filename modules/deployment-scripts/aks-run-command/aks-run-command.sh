#!/bin/bash

set -e +H
# -e to exit on error
# +H to prevent history expansion

if [ "$loopIndex" == "0" ] && [ "$initialDelay" != "0" ]
then
    echo "Waiting on RBAC replication ($initialDelay)"
    sleep $initialDelay

    #Force RBAC refresh
    az logout
    az login --identity
fi

echo "Sending command $command to AKS Cluster $aksName in $RG"
cmdOut=$(az aks command invoke -g $RG -n $aksName -o json --command "${command}")
echo $cmdOut

jsonOutputString=$cmdOut
echo $jsonOutputString > $AZ_SCRIPTS_OUTPUT_PATH
