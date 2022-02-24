provider "vault" {
 address = var.vault_addr
 token = var.vault_token
 namespace = var.namespace
}
variable "vault_addr" {
    default = "https://vault.yourcompany.com:8200"
}
variable "vault_token" {
}
variable "subscription_id" {
}
variable "tenant_id" {
}
variable "client_secret" {
}
variable "client_id" {
}
variable "application_object_id" {
}
variable "namespace" {
}
variable "secret_path" {
}


# azure roles
resource "vault_azure_secret_backend" "azure" {
  use_microsoft_graph_api = true
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_secret   = var.client_secret
  client_id       = var.client_id
  path            = var.secret_path
}

resource "vault_azure_secret_backend_role" "azure-secret-read" {
  backend                     = vault_azure_secret_backend.azure.path
  role                        = "azure-secret-read"
  ttl                         = 300
  max_ttl                     = 600

  azure_roles {
    role_name = "Reader"
    scope =  "/subscriptions/${var.subscription_id}/resourceGroups/azure-vault-group"
  }
}

resource "vault_azure_secret_backend_role" "existing_object_id" {
  backend               = vault_azure_secret_backend.azure.path
  role                  = "existing_object_id"
  application_object_id = var.application_object_id
  ttl                   = 300
  max_ttl               = 600
}
