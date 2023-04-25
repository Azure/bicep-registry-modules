#!/bin/bash
set -e
initialDelay="${initialDelay:-5}"
retryMax="${retryMax:-5}"
certName="${certName:-default-cert}"
certCommonName="${certCommonName:-default}"
validity="${validity:-12}"
akvName="${akvName:-keyvault}"
issuerName="${issuerName:-}"
reuseKey="${reuseKey:-true}"
retrySleep="${retrySleep:-5}"

echo "Waiting on Identity RBAC replication (\"$initialDelay\")"
sleep "$initialDelay"

#Retry loop to catch errors (usually RBAC delays)
retryLoopCount=0
until [ "$retryLoopCount" -ge "$retryMax" ]
do
    echo "Creating AKV Cert $certName with CN $certCommonName (attempt $retryLoopCount)..."

    if [ -z "$issuerName" ] || [ -z "$issuerProvider" ]; then
        policy=$(az keyvault certificate get-default-policy \
            | sed -e s/\"validityInMonths\":\ 12/\"validityInMonths\":\ "${validity}"/g \
            | sed -e s/CN=CLIGetDefaultPolicy/CN="${certCommonName}"/g )
    else
      if [ "$issuerProvider" == "DigiCert" ] || [ "$issuerProvider" == "GlobalCert" ]; then
        az keyvault certificate issuer create \
          --vault-name "$akvName" \
          --issuer-name "$issuerName" \
          --provider-name "$issuerProvider" \
          --account-id "$accountId" \
          --password "$issuerPassword" \
          --organizatiion-id "$organizationId"
      else
        az keyvault certificate issuer create \
          --vault-name "$akvName" \
          --issuer-name "$issuerName" \
          --provider-name "$issuerProvider"
      fi
      policy=$(az keyvault certificate get-default-policy \
        | sed -e s/\"validityInMonths\":\ 12/\"validityInMonths\":\ "${validity}"/g \
        | sed -e s/CN=CLIGetDefaultPolicy/CN="${certCommonName}"/g \
        | sed -e s/\"name\":\ \"Self\"/\"name\":\ \""${issuerName}"\"/g \
        | sed -e s/\"reuseKey\":\ true/\"reuseKey\":\ "${reuseKey}"/g )
    fi
    az keyvault certificate create \
        --vault-name "$akvName" \
        -n "$certName" \
        -p "$policy" \
        --disabled "$disabled" \
        && break

    sleep "$retrySleep"
    retryLoopCount=$((retryLoopCount+1))
done

echo "Getting Certificate $certName";
retryLoopCount=0
createdCert=$(az keyvault certificate show -n "$certName" --vault-name "$akvName" -o json)
while [ -z "$(echo "$createdCert" | jq -r '.x509ThumbprintHex')" ] && [ $retryLoopCount -lt "$retryMax" ]
do
    echo "Waiting for cert creation (attempt $retryLoopCount)..."
    sleep $retrySleep
    createdCert=$(az keyvault certificate show -n $certName --vault-name $akvName -o json)
    retryLoopCount=$((retryLoopCount+1))
done

unversionedSecretId=$(echo $createdCert | jq -r ".sid" | cut -d'/' -f-5) # remove the version from the url;
jsonOutputString=$(echo $createdCert | jq --arg usid $unversionedSecretId '{name: .name ,certSecretId: {versioned: .sid, unversioned: $usid }, thumbprint: .x509Thumbprint, thumbprintHex: .x509ThumbprintHex}')
echo $jsonOutputString > $AZ_SCRIPTS_OUTPUT_PATH
