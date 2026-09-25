#!/bin/bash
# ==============================================================================
# HCI Deployment Script - Full Inline Deployment
# ==============================================================================
# This script handles the complete deployment lifecycle inside the ACI container.
# It mirrors the documented Azure Stack HCI "Validate first, then Deploy" flow
# (as used by the ARM quickstart) so that BOTH portal tiles stay green:
#   1. Idempotency check: skip if Deploy+Succeeded already exists.
#   2. Decode base64-encoded Bicep files.
#   3. Run each requested operation as its OWN, sequential deployment in
#      Validate -> Deploy order (never both fused in a single deployment).
#   4. After Validate, wait until the RP-reported validationStatus is committed
#      before starting Deploy, then Deploy IN PLACE over the same 'default'
#      resource (no delete) so validationStatus is preserved.
#   5. Only a non-succeeded / stale Validate resource is ever deleted.
# This supports every deploymentOperations combination: ['Validate'],
# ['Deploy'], and ['Validate','Deploy'] - with no regression and full
# backward compatibility (the module's public interface is unchanged).
# ==============================================================================

set -e

echo "=== HCI Deployment Script - Full Inline Deployment ==="

# Validate required environment variables
if [ -z "$RESOURCE_GROUP_NAME" ] || [ -z "$SUBSCRIPTION_ID" ] || [ -z "$CLUSTER_NAME" ] || [ -z "$CLUSTER_AD_NAME" ] || [ -z "$CLOUD_ID" ] || [ -z "$USE_SHARED_KEYVAULT" ] || [ -z "$DEPLOYMENT_SETTINGS" ] || [ -z "$DEPLOYMENT_SETTING_BICEP_BASE64" ] || [ -z "$DEPLOYMENT_SETTING_MAIN_BICEP_BASE64" ] || [ -z "$NEED_ARB_SECRET" ] || [ -z "$OPERATION_TYPE" ]; then
    echo "Error: Required environment variables are missing"
    exit 1
fi

# Set subscription context
echo "Setting subscription context to: $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"

# Create directory structure and decode base64 files
echo "Creating required directory structure and bicep files..."
mkdir -p nested
mkdir -p deployment-setting

echo "Decoding deployment-setting.bicep from base64..."
echo "$DEPLOYMENT_SETTING_BICEP_BASE64" | base64 -d > nested/deployment-setting.bicep

echo "Decoding deployment-setting/main.bicep from base64..."
echo "$DEPLOYMENT_SETTING_MAIN_BICEP_BASE64" | base64 -d > deployment-setting/main.bicep

# Verify files
if [ ! -f "nested/deployment-setting.bicep" ] || [ ! -s "nested/deployment-setting.bicep" ]; then
    echo "Error: Failed to create nested/deployment-setting.bicep"
    exit 1
fi
if [ ! -f "deployment-setting/main.bicep" ] || [ ! -s "deployment-setting/main.bicep" ]; then
    echo "Error: Failed to create deployment-setting/main.bicep"
    exit 1
fi

echo "Bicep files created successfully"
echo "nested/deployment-setting.bicep size: $(wc -c < nested/deployment-setting.bicep) bytes"
echo "deployment-setting/main.bicep size: $(wc -c < deployment-setting/main.bicep) bytes"

# Parse deployment operations
IFS=',' read -ra OPERATIONS <<< "$DEPLOYMENT_OPERATIONS"
echo "Deployment operations: ${OPERATIONS[@]}"

OPERATIONS_JSON="["
for i in "${!OPERATIONS[@]}"; do
    if [ $i -gt 0 ]; then
        OPERATIONS_JSON+=","
    fi
    OPERATIONS_JSON+="\"${OPERATIONS[$i]}\""
done
OPERATIONS_JSON+="]"

# Determine which operations are requested (order is enforced Validate -> Deploy below)
DO_VALIDATE="false"
DO_DEPLOY="false"
for op in "${OPERATIONS[@]}"; do
    case "$op" in
        Validate) DO_VALIDATE="true" ;;
        Deploy) DO_DEPLOY="true" ;;
    esac
done

# Convert boolean values
USE_SHARED_KEYVAULT_JSON=$(echo "$USE_SHARED_KEYVAULT" | tr '[:upper:]' '[:lower:]')
if [ "$USE_SHARED_KEYVAULT_JSON" = "true" ] || [ "$USE_SHARED_KEYVAULT_JSON" = "1" ]; then
    USE_SHARED_KEYVAULT_JSON="true"
else
    USE_SHARED_KEYVAULT_JSON="false"
fi

NEED_ARB_SECRET_JSON=$(echo "$NEED_ARB_SECRET" | tr '[:upper:]' '[:lower:]')
if [ "$NEED_ARB_SECRET_JSON" = "true" ] || [ "$NEED_ARB_SECRET_JSON" = "1" ]; then
    NEED_ARB_SECRET_JSON="true"
else
    NEED_ARB_SECRET_JSON="false"
fi

# Validate DEPLOYMENT_SETTINGS is valid JSON
if ! echo "$DEPLOYMENT_SETTINGS" | jq empty 2>/dev/null; then
    echo "Error: DEPLOYMENT_SETTINGS is not valid JSON"
    exit 1
fi

DEPLOYMENT_SETTINGS_RESOURCE_ID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.AzureStackHCI/clusters/$CLUSTER_NAME/deploymentSettings/default"
PARAM_FILE="deployment-params.json"

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------

resource_exists() {
    az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" >/dev/null 2>&1
}

get_mode() {
    az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --query "properties.deploymentMode" --output tsv 2>/dev/null || true
}

get_state() {
    az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --query "properties.provisioningState" --output tsv 2>/dev/null || true
}

write_output() {
    # $1 = message
    cat > "$AZ_SCRIPTS_OUTPUT_PATH" << EOF
{
  "status": "success",
  "message": "$1",
  "operations": $OPERATIONS_JSON
}
EOF
}

# Write the ARM parameter file for a single deployment operation.
# $1 = JSON array of operations for this pass, e.g. ["Validate"] or ["Deploy"].
write_param_file() {
    local ops_json="$1"
    cat > "$PARAM_FILE" << EOF
{
  "\$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "deploymentOperations": {
      "value": $ops_json
    },
    "deploymentSettings": {
      "value": $DEPLOYMENT_SETTINGS
    },
    "useSharedKeyVault": {
      "value": $USE_SHARED_KEYVAULT_JSON
    },
    "clusterName": {
      "value": "$CLUSTER_NAME"
    },
    "clusterADName": {
      "value": "$CLUSTER_AD_NAME"
    },
    "operationType": {
      "value": "$OPERATION_TYPE"
    },
    "cloudId": {
      "value": "$CLOUD_ID"
    },
    "needArbSecret": {
      "value": $NEED_ARB_SECRET_JSON
    }
  }
}
EOF
    if ! jq empty "$PARAM_FILE" 2>/dev/null; then
        echo "Error: Generated parameter file is not valid JSON"
        cat "$PARAM_FILE"
        exit 1
    fi
}

# Run a single-operation deployment ($1 = "Validate" or "Deploy").
run_deployment() {
    local op="$1"
    write_param_file "[\"$op\"]"
    local op_lower
    op_lower=$(echo "$op" | tr '[:upper:]' '[:lower:]')
    local deployment_name="hci-deployment-${op_lower}-$(date +%s)"
    echo "Starting ${op} deployment: ${deployment_name}"

    if az deployment group create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$deployment_name" \
        --template-file "nested/deployment-setting.bicep" \
        --parameters "@$PARAM_FILE" \
        --verbose; then
        echo "${op} deployment completed successfully"
    else
        local rc=$?
        echo "${op} deployment failed with status: $rc"
        az deployment group show \
            --resource-group "$RESOURCE_GROUP_NAME" \
            --name "$deployment_name" \
            --query "properties.error" \
            --output json 2>/dev/null || true
        exit $rc
    fi
}

# After a successful Validate, wait until the RP-reported validationStatus is
# committed (non-empty) so the subsequent in-place Deploy preserves it. This is
# best-effort: it never fails the deployment, it only avoids the race where a
# Deploy PUT lands before the validation record is durably written.
wait_for_validation_commit() {
    echo "Waiting for validationStatus to be committed before Deploy..."
    local attempts=0
    local max_attempts=12   # ~3 minutes at 15s intervals
    local vs committed
    while [ $attempts -lt $max_attempts ]; do
        vs=$(az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --query "properties.reportedProperties.validationStatus" --output json 2>/dev/null || echo '{}')
        committed=$(echo "$vs" | jq -r 'if (type=="object" and (length>0)) then "yes" else "no" end' 2>/dev/null || echo "no")
        if [ "$committed" = "yes" ]; then
            echo "validationStatus committed."
            return 0
        fi
        attempts=$((attempts + 1))
        sleep 15
    done
    echo "WARNING: validationStatus not observed as committed after wait; proceeding with Deploy."
    return 0
}

# ------------------------------------------------------------------------------
# Pre-flight state check (preserves original Deploy-state semantics)
# ------------------------------------------------------------------------------
echo "Checking resource: $DEPLOYMENT_SETTINGS_RESOURCE_ID"

if resource_exists; then
    CURRENT_MODE=$(get_mode)
    CURRENT_STATE=$(get_state)
    echo "Existing resource — Mode: $CURRENT_MODE, State: $CURRENT_STATE"

    if [ "$CURRENT_MODE" = "Deploy" ] && [ "$CURRENT_STATE" = "Succeeded" ]; then
        echo "Deploy+Succeeded already exists. Skipping deployment."
        write_output "Deployment already succeeded - skipped"
        exit 0
    elif [ "$CURRENT_MODE" = "Deploy" ] && [ "$CURRENT_STATE" != "Succeeded" ]; then
        echo "Deploy mode in state: $CURRENT_STATE (not Succeeded). Failing."
        exit 1
    fi
    # Otherwise the resource is in Validate mode and is handled by the phases below.
else
    echo "No existing deploymentSettings resource. Proceeding with deployment..."
fi

# ------------------------------------------------------------------------------
# Validate phase
# ------------------------------------------------------------------------------
if [ "$DO_VALIDATE" = "true" ]; then
    if resource_exists; then
        CURRENT_MODE=$(get_mode)
        CURRENT_STATE=$(get_state)
        if [ "$CURRENT_MODE" = "Validate" ] && [ "$CURRENT_STATE" = "Succeeded" ]; then
            echo "Validate already succeeded; skipping re-validation (preserving validationStatus)."
        else
            # Stale / failed Validate resource: remove it so validation starts clean.
            echo "Validate in non-succeeded state ($CURRENT_STATE); removing stale resource..."
            if az resource delete --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --only-show-errors; then
                echo "Stale validation resource deleted. Proceeding with validation..."
            else
                echo "Failed to delete validation resource."
                exit 1
            fi
            run_deployment "Validate"
        fi
    else
        run_deployment "Validate"
    fi

    # Only wait for the validation record when we will subsequently Deploy over it.
    if [ "$DO_DEPLOY" = "true" ]; then
        wait_for_validation_commit
    fi
fi

# ------------------------------------------------------------------------------
# Deploy phase (in place; never deletes a succeeded Validate)
# ------------------------------------------------------------------------------
if [ "$DO_DEPLOY" = "true" ]; then
    if resource_exists; then
        CURRENT_MODE=$(get_mode)
        CURRENT_STATE=$(get_state)
        if [ "$CURRENT_MODE" = "Deploy" ] && [ "$CURRENT_STATE" = "Succeeded" ]; then
            echo "Deploy+Succeeded already exists. Skipping Deploy."
            rm -f "$PARAM_FILE"
            rm -rf "nested" "deployment-setting"
            write_output "Deployment already succeeded - skipped"
            exit 0
        elif [ "$CURRENT_MODE" = "Validate" ] && [ "$CURRENT_STATE" = "Succeeded" ]; then
            echo "Preserving succeeded Validate; deploying in place over 'default' (keeps validationStatus)."
        else
            echo "Proceeding to Deploy over existing resource (Mode: $CURRENT_MODE, State: $CURRENT_STATE)."
        fi
    fi
    run_deployment "Deploy"
fi

# Clean up temporary files
rm -f "$PARAM_FILE"
rm -rf "nested" "deployment-setting"

echo "HCI deployment completed successfully!"

# Set output for Bicep usage
write_output "Deployment completed successfully"
