resource "azurerm_key_vault" "this" {
  name                = "${module.naming.key_vault.name}-${var.location}-${var.environment}-${var.owner}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"


  access_policy {
    object_id = "9ad75dee-6105-4ffd-9c88-8255904692c0"
    tenant_id = data.azurerm_client_config.current.tenant_id

    secret_permissions = [
      "Get", "List", "Purge", "Delete", "Backup", "Recover", "Restore", "Set"
    ]
  }
  access_policy {
    object_id = "8c443125-3a52-47a1-9011-4a6a823cbd1a"
    tenant_id = data.azurerm_client_config.current.tenant_id

    secret_permissions = [
      "Get", "List", "Purge", "Delete", "Backup", "Recover", "Restore", "Set"
    ]
  }

}

resource "azurerm_key_vault_secret" "this" {
  name         = "kubeconfig"
  key_vault_id = azurerm_key_vault.this.id
  value        = azurerm_kubernetes_cluster.this.kube_config_raw

}