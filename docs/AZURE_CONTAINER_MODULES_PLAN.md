# Plan: Terraform Modules for Azure Docker Deployment (Hunyuan3D-2GP)

## Objective

Enable deployment of Hunyuan3D-2GP in an Azure Docker image by adding required terraform modules to terrasmth.

---

## Required Modules

### 1. Azure Container Registry (ACR)

- **Purpose:** Store and manage Docker images for deployment.
- **Module Structure:**
  - `main.tf`: Defines `azurerm_container_registry` resource.
  - `variables.tf`: Registry name, SKU, admin access, etc.
  - `outputs.tf`: Registry login server, credentials, etc.
  - `README.md`: Usage instructions.

### 2. Azure Container Instances (ACI)

- **Purpose:** Run Docker containers in Azure.
- **Module Structure:**
  - `main.tf`: Defines `azurerm_container_group` resource.
  - `variables.tf`: Container image, CPU/memory, networking, etc.
  - `outputs.tf`: Container group IP, FQDN, etc.
  - `README.md`: Usage instructions.

---

## Integration

- Reference networking, resource group, and security modules from new container modules.
- Provide example/test configurations for deploying Hunyuan3D-2GP as a container.

---

## Next Steps

1. Create new modules for ACR and ACI under `terraform/elementary_modules/azure/`.
2. Document usage and integration with Hunyuan3D-2GP deployment.
3. Optionally, add sample terragrunt configurations for container deployment.

---

## Summary

- **Missing Modules:** No terraform modules for ACR or ACI are present.
- **Action:** Add modules as described above. No changes will be made until these modules are implemented.
