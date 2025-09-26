locals {
  tenant_id       = get_env("ARM_TENANT_ID", "")
  subscription_id = get_env("ARM_SUBSCRIPTION_ID", "")
  
  # Hunyuan3D-2GP specific configuration
  project_name    = "hunyuan3d-2gp"
  location        = "East US"  # GPU instances availability
  
  # Memory profile configuration (1-5, where 4 is default for 6GB VRAM)
  memory_profile  = get_env("HUNYUAN3D_MEMORY_PROFILE", "4")
  enable_texture  = get_env("HUNYUAN3D_ENABLE_TEXTURE", "false")
  
  # Container configuration
  container_cpu    = "4.0"
  container_memory = "16.0"
  api_port        = "8080"
  
  # Common tags
  common_tags = {
    Environment = "hunyuan3d-2gp"
    Project     = "3D-Generation-API"
    ManagedBy   = "Terragrunt"
    Purpose     = "ML-Inference"
  }
}