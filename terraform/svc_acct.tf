resource "azuread_application" "app" {
  display_name = "test-application"
  owners = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "sp" {
  application_id = azuread_application.app.application_id
  app_role_assignment_required = false
  owners = [data.azuread_client_config.current.object_id]
}

resource "time_rotating" "spin" {
  rotation_days = 1
}


resource "azuread_service_principal_password" "sp" {
  service_principal_id = azuread_application.app.id
  rotate_when_changed = {
    "rotation" = time_rotating.spin.id
  }
}

resource "azurerm_key_vault_secret" "appid" {
  name = "${azuread_application.app.display_name}-app-id"
  value = azuread_application.app.application_id
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "pass" {
  name = "${azuread_application.app.display_name}-app-secret"
  value = azuread_service_principal_password.sp.value
  key_vault_id = azurerm_key_vault.this.id
}