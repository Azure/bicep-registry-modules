#!/bin/bash
set -e

echo "Running az cli command"
jsonOutputString=$(az account show)

echo $jsonOutputString
echo $jsonOutputString > $AZ_SCRIPTS_OUTPUT_PATH
