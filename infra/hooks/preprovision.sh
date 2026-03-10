#!/bin/bash

# Prompt for resource group name if not already set
rgName=$(azd env get-value AZURE_RESOURCE_GROUP_NAME 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$rgName" ] || echo "$rgName" | grep -q "ERROR:"; then
    echo "Note: If the resource group already exists, the location will be picked from the resource group location."
    printf "Enter the Azure resource group name: "
    read rgName
    if [ -z "$rgName" ]; then
        echo "Error: Resource group name is required."
        exit 1
    fi
    azd env set AZURE_RESOURCE_GROUP_NAME "$rgName"
fi

echo "Using resource group: $rgName"

# Check if the resource group already exists
rgJson=$(az group show --name "$rgName" 2>/dev/null)
if [ $? -eq 0 ] && [ -n "$rgJson" ]; then
    rgLocation=$(echo "$rgJson" | jq -r '.location')
    echo "Resource group '$rgName' already exists in location '$rgLocation'. Using that location."
    azd env set AZURE_LOCATION "$rgLocation"
else
    echo "Resource group '$rgName' does not exist yet. It will be created during provisioning."
fi
