#!/bin/bash

# Usage: source ./set-azure-env.sh
# This script sets ARM_SUBSCRIPTION_ID and ARM_TENANT_ID for the current shell session using Azure CLI.

# Check if az CLI is installed
if ! command -v az &> /dev/null; then
  echo "Error: Azure CLI (az) is not installed. Please install it first."
  return 1 2>/dev/null || exit 1
fi

# Check if user is logged in to Azure
if ! az account show &> /dev/null; then
  echo "Error: Not logged in to Azure CLI. Please run 'az login' first."
  return 1 2>/dev/null || exit 1
fi

export ARM_SUBSCRIPTION_ID="$(az account show --query id --output tsv)"
export ARM_TENANT_ID="$(az account show --query tenantId --output tsv)"

echo "ARM_SUBSCRIPTION_ID set to: $ARM_SUBSCRIPTION_ID"
echo "ARM_TENANT_ID set to: $ARM_TENANT_ID"
echo "Environment variables have been set for this session."
