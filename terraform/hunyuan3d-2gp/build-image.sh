#!/bin/bash
set -e

# Hunyuan3D-2GP Docker Build and Push Script
# This script builds the Docker image and pushes it to Azure Container Registry

# Configuration - matches terragrunt configuration
REGISTRY_NAME="hunyuan3d2gpacr"
IMAGE_NAME="hunyuan3d-2gp-api"
TAG="latest"
RESOURCE_GROUP="hunyuan3d-2gp-rg"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Building Hunyuan3D-2GP Docker Image...${NC}"

# Build the Docker image
echo -e "${YELLOW}Building Docker image: ${IMAGE_NAME}:${TAG}${NC}"
docker build -t ${IMAGE_NAME}:${TAG} .

# Tag for Azure Container Registry
FULL_IMAGE_NAME="${REGISTRY_NAME}.azurecr.io/${IMAGE_NAME}:${TAG}"
echo -e "${YELLOW}Tagging image as: ${FULL_IMAGE_NAME}${NC}"
docker tag ${IMAGE_NAME}:${TAG} ${FULL_IMAGE_NAME}

echo -e "${GREEN}Docker image built successfully!${NC}"
echo -e "${YELLOW}To push to Azure Container Registry:${NC}"
echo "1. Ensure you're logged into Azure: az login"
echo "2. Login to ACR: az acr login --name ${REGISTRY_NAME}"
echo "3. Push image: docker push ${FULL_IMAGE_NAME}"

# Optional: Push immediately if registry exists and user is authenticated
read -p "Do you want to push to Azure Container Registry now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Logging into Azure Container Registry...${NC}"
    az acr login --name ${REGISTRY_NAME}
    
    echo -e "${YELLOW}Pushing image to registry...${NC}"
    docker push ${FULL_IMAGE_NAME}
    
    echo -e "${GREEN}Image pushed successfully!${NC}"
    echo -e "${YELLOW}Image URI: ${FULL_IMAGE_NAME}${NC}"
fi