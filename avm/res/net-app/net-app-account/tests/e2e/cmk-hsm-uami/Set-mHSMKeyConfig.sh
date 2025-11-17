echo "Checking role assignment for HSM: $1, Key: $2, Principal: $3"
# Allow key reference via identity
result=$(az keyvault role assignment list --hsm-name "$1" --scope "/keys/$2" --query "[?principalId == \`$3\` && roleName == \`Managed HSM Crypto Service Encryption User\`]")

if [[ "$result" != "[]" ]]; then
  echo "Role assignment already exists."
else
  echo "Role assignment not yet existing. Creating."
  az keyvault role assignment create --hsm-name "$1" --role "Managed HSM Crypto User" --scope "/keys/$2" --assignee $3
fi

# Allow usage via ARM
az keyvault setting update --hsm-name $1 --name 'AllowKeyManagementOperationsThroughARM' --value 'true'
