resource "azurerm_kubernetes_cluster" "this" {
  name                = module.naming.kubernetes_cluster.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  dns_prefix = "woot"

  automatic_channel_upgrade = "stable"


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
