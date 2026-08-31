#!/bin/bash
set -e
set -o pipefail

KEY_VAULT_SUBSCRIPTION_ID="$1"
KEY_VAULT_NAME="$2"
SSH_PUBLIC_KEY_SECRET_NAME="$3"
SSH_PRIVATE_KEY_SECRET_NAME="$4"

n=0
sign_in_exit_code=-1
until [[ "$n" -ge 5 ]]; do
  az login --identity --allow-no-subscriptions --output none && sign_in_exit_code=0 && break
  n=$((n + 1))
  sleep 15
done

if [[ $sign_in_exit_code -ne 0 ]]; then
  echo 'Failed logging in with the shell managed identity.' >&2
  exit 1
fi

az account set --subscription "$KEY_VAULT_SUBSCRIPTION_ID"

private_key_file=rsakey
public_key_file="${private_key_file}.pub"

private_key_count=$(az keyvault secret list \
  --subscription "$KEY_VAULT_SUBSCRIPTION_ID" \
  --vault-name "$KEY_VAULT_NAME" \
  --query "length([?name=='${SSH_PRIVATE_KEY_SECRET_NAME}'])" \
  --only-show-errors \
  --output tsv)

if [[ "$private_key_count" -gt 0 ]]; then
  echo 'Found existing private key in Key Vault. Reusing the existing SSH key pair.'
else
  echo 'Private key not found in Key Vault. Generating a new SSH key pair.'
  rm -f "$private_key_file" "$public_key_file"

  if command -v ssh-keygen >/dev/null 2>&1; then
    ssh-keygen -q -t rsa -N '' -b 4096 -f "./${private_key_file}"
  elif command -v openssl >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1; then
    echo 'ssh-keygen is unavailable. Generating the RSA-4096 key pair with OpenSSL.'
    openssl genrsa -traditional -out "$private_key_file" 4096

    modulus_output=$(openssl rsa -in "$private_key_file" -noout -modulus)
    modulus_hex=${modulus_output#Modulus=}

    MODULUS_HEX="$modulus_hex" PUBLIC_KEY_FILE="$public_key_file" python3 <<'PY'
import base64
import os
import struct


def encode_ssh_string(value):
    return struct.pack(">I", len(value)) + value


def encode_mpint(value):
    encoded = value.to_bytes((value.bit_length() + 7) // 8, "big")
    if encoded and encoded[0] & 0x80:
        encoded = b"\x00" + encoded
    return encode_ssh_string(encoded)


exponent = 65537
modulus = int(os.environ["MODULUS_HEX"], 16)
key_blob = encode_ssh_string(b"ssh-rsa") + encode_mpint(exponent) + encode_mpint(modulus)
public_key = b"ssh-rsa " + base64.b64encode(key_blob) + b"\n"

with open(os.environ["PUBLIC_KEY_FILE"], "wb") as public_key_file:
    public_key_file.write(public_key)
PY
  else
    echo 'Neither ssh-keygen nor the OpenSSL and Python fallback are available in the deployment script container.' >&2
    exit 1
  fi

  if [[ ! -s "$private_key_file" || ! -s "$public_key_file" ]]; then
    echo 'SSH key generation did not create both the private and public key files.' >&2
    exit 1
  fi

  az keyvault secret set \
    --name "$SSH_PRIVATE_KEY_SECRET_NAME" \
    --file "$private_key_file" \
    --subscription "$KEY_VAULT_SUBSCRIPTION_ID" \
    --vault-name "$KEY_VAULT_NAME" \
    --only-show-errors \
    --output none

  az keyvault secret set \
    --name "$SSH_PUBLIC_KEY_SECRET_NAME" \
    --file "$public_key_file" \
    --subscription "$KEY_VAULT_SUBSCRIPTION_ID" \
    --vault-name "$KEY_VAULT_NAME" \
    --only-show-errors \
    --output none
fi

public_key_json=$(az keyvault secret show \
  --name "$SSH_PUBLIC_KEY_SECRET_NAME" \
  --subscription "$KEY_VAULT_SUBSCRIPTION_ID" \
  --vault-name "$KEY_VAULT_NAME" \
  --query value \
  --only-show-errors \
  --output json)

printf '{"sshPublicKey":%s}\n' "$public_key_json" > "$AZ_SCRIPTS_OUTPUT_PATH"

rm -f "$private_key_file" "$public_key_file"
