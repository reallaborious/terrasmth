locals {
  tenant_id        = get_env("ARM_TENANT_ID", "3d8b1120-02fd-463d-94ce-df8c743170f2")
  subscription_id  = "24246c45-86af-407e-993c-1883f8735933"
  location="westus"
  vm_size="Standard_NC6s_v3"

  # GPU deployment toggles and settings
  gpu_enabled=true
  gpu_vendor="nvidia"
  nvidia_cuda_version="12.4"
  nvidia_container_toolkit=true
  # Hint for playbooks that Ollama should use GPU
  ollama_gpu=true
}
