#!/bin/bash

echo "${ZIP_FILE}" | base64 -d > $FILE_NAME
az functionapp deploy --resource-group $RESOURCE_GROUP_NAME --name $FUNCTION_APP_NAME --src-path $FILE_NAME --type zip