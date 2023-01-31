#!/bin/bash
set -e

echo "Waiting on Identity RBAC replication ($initialDelay)"
sleep $initialDelay

#Retry loop to catch errors (usually RBAC delays)
retryLoopCount=0
until [ $retryLoopCount -ge $retryMax ]
do
    echo "Creating AKV Cert $certName with CN $certCommonName (attempt $retryLoopCount)..."

    if [ -z "$issuerName" ] || [ -z "$issuerProvider" ]; then
      az keyvault certificate create \
        --vault-name $akvName \
        -n $certName \
        -p "$(az keyvault certificate get-default-policy \
        | sed -e s/CN=CLIGetDefaultPolicy/CN=${certCommonName}/g )" \
        && break
    else
      az keyvault certificate issuer create \
        --vault-name $akvName \
        --issuer-name $issuerName \
        --provider-name $issuerProvider
      az keyvault certificate create \
        --vault-name $akvName \
        -n $certName \
        -p "$(az keyvault certificate get-default-policy \
        | sed -e s/Self/${issuerName}/g \
        | sed -e s/CN=CLIGetDefaultPolicy/CN=${certCommonName}/g )" \
        && break
    fi

    sleep $retrySleep
    retryLoopCount=$((retryLoopCount+1))
done

echo "Getting Certificate $certName";
retryLoopCount=0
createdCert=$(az keyvault certificate show -n $certName --vault-name $akvName -o json)
while [ -z "$(echo $createdCert | jq -r '.x509ThumbprintHex')" ] && [ $retryLoopCount -lt $retryMax ]
do
    echo "Waiting for cert creation (attempt $retryLoopCount)..."
    sleep $retrySleep
    createdCert=$(az keyvault certificate show -n $certName --vault-name $akvName -o json)
    retryLoopCount=$((retryLoopCount+1))
done

unversionedSecretId=$(echo $createdCert | jq -r ".sid" | cut -d'/' -f-5) # remove the version from the url;
jsonOutputString=$(echo $createdCert | jq --arg usid $unversionedSecretId '{name: .name ,certSecretId: {versioned: .sid, unversioned: $usid }, thumbprint: .x509Thumbprint, thumbprintHex: .x509ThumbprintHex}')
echo $jsonOutputString > $AZ_SCRIPTS_OUTPUT_PATH
