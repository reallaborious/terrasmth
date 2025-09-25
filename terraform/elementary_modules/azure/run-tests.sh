#!/bin/bash

# Terraform Test Runner for Azure Modules
# Usage: ./run-tests.sh [subscription-id]
# 
# Examples:
#   ./run-tests.sh 00000000-0000-0000-0000-000000000000
#   ./run-tests.sh  # Uses current Azure CLI subscription

set -e

# Get subscription ID from parameter or Azure CLI
if [ -n "$1" ]; then
    SUBSCRIPTION_ID="$1"
    echo "Using provided subscription ID: $SUBSCRIPTION_ID"
else
    SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null || echo "")
    if [ -z "$SUBSCRIPTION_ID" ]; then
        echo "Error: No subscription ID provided and Azure CLI not authenticated"
        echo "Usage: $0 [subscription-id]"
        echo "Or run: az login first"
        exit 1
    fi
    echo "Using Azure CLI subscription ID: $SUBSCRIPTION_ID"
fi

# Export environment variable for Terraform
export ARM_SUBSCRIPTION_ID="$SUBSCRIPTION_ID"

# Test all modules
MODULES=(
    "public_ip"
    "network_interface"
    "network_security_group"
    "nsg_subnet_association"
)

echo ""
echo "🧪 Running Terraform tests for all Azure modules..."
echo "Subscription: $ARM_SUBSCRIPTION_ID"
echo ""

FAILED_MODULES=()
PASSED_MODULES=()

for module in "${MODULES[@]}"; do
    echo "📦 Testing module: $module"
    echo "----------------------------------------"
    
    cd "/home/nikto/projects/terrasmth/terraform/elementary_modules/azure/$module"
    
    if terraform test; then
        echo "✅ $module: PASSED"
        PASSED_MODULES+=("$module")
    else
        echo "❌ $module: FAILED"
        FAILED_MODULES+=("$module")
    fi
    
    echo ""
done

# Summary
echo "📊 TEST SUMMARY"
echo "==============="
echo "✅ Passed: ${#PASSED_MODULES[@]} modules"
for module in "${PASSED_MODULES[@]}"; do
    echo "   - $module"
done

if [ ${#FAILED_MODULES[@]} -gt 0 ]; then
    echo "❌ Failed: ${#FAILED_MODULES[@]} modules"
    for module in "${FAILED_MODULES[@]}"; do
        echo "   - $module"
    done
    exit 1
else
    echo "🎉 All tests passed!"
fi