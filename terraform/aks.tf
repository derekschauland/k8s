resource "azurerm_kubernetes_cluster" "this" {
  name                = module.naming.kubernetes_cluster.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  dns_prefix = "lab"

  automatic_channel_upgrade = "stable"
  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = [azuread_group.this.object_id]
  }


  ingress_application_gateway {
    subnet_id = azurerm_subnet.appgw.id
    #subnet_id = data.azurerm_subnet.appgw_subnet.id
  }


  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "standard_D2_V2"
    os_disk_size_gb = "80"
    os_disk_type    = "Managed"
    vnet_subnet_id  = azurerm_subnet.default.id
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = "10.42.0.0/16"
    dns_service_ip     = "10.42.0.69"
    docker_bridge_cidr = "10.42.0.0/16"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags


}

resource "azuread_group" "this" {
  display_name     = "k8s_admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

data "azuread_user" "user" {
  user_principal_name = "derekschauland_outlook.com#EXT#@derekschaulandoutlook.onmicrosoft.com"
}

resource "azuread_group_member" "this" {
  group_object_id  = azuread_group.this.object_id
  member_object_id = data.azuread_user.user.id

}