# Hunyuan3D-2GP Azure Infrastructure Deployment Plan

## Overview

This document outlines the complete infrastructure architecture for deploying the Hunyuan3D-2GP API server on Azure using Terraform and Terragrunt. The deployment provides a scalable, GPU-enabled container infrastructure capable of handling 3D generation workloads.

---

## Application Analysis

### Hunyuan3D-2GP Requirements
Based on the API server analysis (`api_server.py`), the application requires:

**Computational Requirements:**
- **GPU**: CUDA-enabled GPUs with 6GB+ VRAM minimum (24.5GB for full texture generation)
- **CPU**: Multi-core processor for model inference
- **RAM**: 16GB+ recommended for model loading and processing
- **Storage**: 50GB+ for models, cache, and temporary files

**Application Specifications:**
- **Runtime**: Python 3.10+ with PyTorch, CUDA support
- **API Server**: FastAPI on port 8080 (configurable)
- **Models**: Downloads from Hugging Face (tencent/Hunyuan3D-2mini, etc.)
- **Features**: Image-to-3D, Text-to-3D, texture generation, mesh processing
- **Endpoints**: `/generate`, `/send`, `/status/{uid}`

---

## Infrastructure Architecture

### Azure Services Required

#### 1. **Container Registry (ACR)**
- **Purpose**: Store the Hunyuan3D-2GP Docker images
- **SKU**: Standard (supports geo-replication)
- **Features**: Admin access, vulnerability scanning

#### 2. **Container Instances (ACI)**  
- **Purpose**: Run the GPU-enabled containers
- **GPU SKU**: K80, P100, V100, or T4 instances
- **CPU/Memory**: 4+ vCPUs, 16GB+ RAM
- **Storage**: Azure Files for model persistence

#### 3. **Virtual Network & Security**
- **VNet**: Isolated network for container communication  
- **NSG**: Security rules for API access (port 8080)
- **Public IP**: Load balancer for external API access

#### 4. **Storage Account**
- **Purpose**: Persistent storage for models and cache
- **Performance**: Premium SSD for fast model loading
- **Redundancy**: LRS (Locally Redundant Storage)

#### 5. **Key Vault**
- **Purpose**: Secure storage of API keys and secrets
- **Access**: Managed identity integration

---

## Deployment Strategy

### Container Configuration

```dockerfile
# Expected container configuration
FROM nvidia/cuda:11.8-devel-ubuntu20.04

# Install Python 3.10, PyTorch with CUDA
# Copy application code and requirements
# Set up model download and caching
# Expose port 8080

ENTRYPOINT ["python", "api_server.py", "--host", "0.0.0.0", "--port", "8080"]
```

### Infrastructure Components

#### Resource Hierarchy:
```
├── Resource Group (hunyuan3d-rg)
├── Virtual Network (hunyuan3d-vnet)  
├── Network Security Group (hunyuan3d-nsg)
├── Storage Account (hunyuan3dstorage)
├── Key Vault (hunyuan3d-kv)
├── Container Registry (hunyuan3dacr)
└── Container Instances (hunyuan3d-api)
```

### Memory Profiles Support:
The infrastructure supports the 5 memory profiles mentioned in the README:
1. **HighRAM_HighVRAM** (Profile 1): V100 instances with 32GB RAM
2. **HighRAM_LowVRAM** (Profile 2): Standard instances with optimized GPU sharing
3. **LowRAM_HighVRAM** (Profile 3): GPU-optimized with 16GB RAM  
4. **LowRAM_LowVRAM** (Profile 4): Balanced configuration (6GB VRAM)
5. **VerylowRAM_LowVRAM** (Profile 5): Minimal configuration

---

## Terragrunt Module Structure

### Configuration Organization:
```
terragrunt/hunyuan3d-2gp/
├── terragrunt.hcl                 # Root configuration
├── resource_group/
│   └── terragrunt.hcl            # Resource group setup
├── network/
│   └── terragrunt.hcl            # VNet and subnets  
├── network_security_group/
│   └── terragrunt.hcl            # Security rules
├── storage/
│   └── terragrunt.hcl            # Storage account
├── keyvault/
│   └── terragrunt.hcl            # Key vault for secrets
├── container_registry/
│   └── terragrunt.hcl            # ACR configuration
└── container_instances/
    └── terragrunt.hcl            # GPU container deployment
```

### Environment Variables:
```bash
# Required for deployment
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id" 
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"

# Hunyuan3D specific
export HUNYUAN3D_MEMORY_PROFILE="4"  # Default to profile 4 (6GB VRAM)
export HUNYUAN3D_ENABLE_TEXTURE="false"  # Disable texture by default
```

---

## Deployment Steps

### Prerequisites:
1. Azure CLI installed and authenticated
2. Terraform >= 1.0
3. Terragrunt >= 0.35
4. Docker for building custom images

### Deployment Process:

#### Phase 1: Foundation Infrastructure
```bash
# Deploy in order
terragrunt run-all plan --terragrunt-working-dir terragrunt/hunyuan3d-2gp/resource_group
terragrunt run-all plan --terragrunt-working-dir terragrunt/hunyuan3d-2gp/network  
terragrunt run-all plan --terragrunt-working-dir terragrunt/hunyuan3d-2gp/storage
```

#### Phase 2: Security and Registry
```bash  
terragrunt run-all plan --terragrunt-working-dir terragrunt/hunyuan3d-2gp/keyvault
terragrunt run-all plan --terragrunt-working-dir terragrunt/hunyuan3d-2gp/container_registry
```

#### Phase 3: Application Deployment
```bash
terragrunt run-all plan --terragrunt-working-dir terragrunt/hunyuan3d-2gp/container_instances
```

---

## Cost Optimization

### GPU Instance Recommendations:
- **Development**: Standard_NC6s_v3 (1x V100, ~$3/hour)
- **Production**: Standard_NC12s_v3 (2x V100, ~$6/hour)  
- **High Scale**: Standard_NC24s_v3 (4x V100, ~$12/hour)

### Storage Optimization:
- Use Azure Files for model persistence
- Implement model caching strategies
- Consider Reserved Instances for long-term deployments

### Scaling Strategy:
- Container Instances can scale based on demand
- Load balancer for multiple instance deployment
- Auto-scaling based on queue length metrics

---

## Security Considerations

### Network Security:
- Private endpoints for storage access
- NSG rules restricting API access to specific IPs
- HTTPS termination at load balancer

### Data Protection:
- Encryption at rest for storage accounts
- Key Vault for sensitive configuration
- Managed identity for service authentication

### Compliance:
- All components deployed in specified regions
- Audit logging enabled
- Resource tagging for governance

---

## Monitoring and Maintenance  

### Health Checks:
- Container health probes on `/status` endpoint
- Application Insights integration
- Custom metrics for generation queue length

### Backup Strategy:
- Regular backup of custom models
- Configuration backup via Git
- Disaster recovery procedures

### Updates:
- Rolling deployment for application updates
- Infrastructure versioning with Terragrunt
- Model version management

---

## Next Steps

1. **Infrastructure Deployment**: Execute terragrunt configurations
2. **Container Image Build**: Create optimized Docker images  
3. **Model Optimization**: Implement efficient model loading
4. **Performance Testing**: Validate GPU utilization and API response times
5. **Production Hardening**: Security review and compliance verification

---

This architecture provides a production-ready foundation for deploying Hunyuan3D-2GP with enterprise-grade security, scalability, and maintainability.