locals {
  tenant_id        = get_env("ARM_TENANT_ID", "")
  subscription_id  = get_env("ARM_SUBSCRIPTION_ID", "")
}