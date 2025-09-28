locals {
  tenant_id       = get_env("ARM_TENANT_ID", "")
  subscription_id = get_env("ARM_SUBSCRIPTION_ID", "")
  
  # Hunyuan3D-2GP specific configuration
  project_name    = "hunyuan3d-2gp"
  location        = "East US"  # GPU instances availability
  
  # Static storage account name (max 24 chars, lowercase + numbers only)
  storage_account_name = "hy3dstor09271919"
  
  # File share name for model cache
  model_share_name = "hunyuan3d-models"
  
  # Memory profile configuration (1-5, where 4 is default for 6GB VRAM)
  memory_profile  = get_env("HUNYUAN3D_MEMORY_PROFILE", "4")
  enable_texture  = get_env("HUNYUAN3D_ENABLE_TEXTURE", "false")
  
  # Container configuration optimized for GPU workloads
  container_cpu    = "4.0"    # Max CPU cores available in quota (4 core limit)
  container_memory = "16.0"   # Adjusted memory for 4 core allocation
  api_port        = "8081"    # Match Hunyuan3D-2GP default port
  
  # Common tags
  common_tags = {
    Environment = "hunyuan3d-2gp"
    Project     = "3D-Generation-API"
    ManagedBy   = "Terragrunt"
    Purpose     = "ML-Inference"
  }
}