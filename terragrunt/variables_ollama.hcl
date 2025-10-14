locals {
  tenant_id        = get_env("ARM_TENANT_ID", "3d8b1120-02fd-463d-94ce-df8c743170f2")
  subscription_id  = "24246c45-86af-407e-993c-1883f8735933"
  location="westus"
  vm_size="Standard_NC6s_v3"
}
