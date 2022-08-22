terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.27.0"
    }
  }
  backend "remote" {
    organization = "derek2-training"
    workspaces {
      name = "tf-aks-3"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

}

provider "azuread" {
  tenant_id = "c9e98357-d330-4626-b83e-b252cfe54eb9"
}

locals {
  tags = {
    owner       = var.owner
    environment = var.environment
    namespace   = var.namespace
  }
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.1.1"

}

resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-${var.location}-aks"
  location = var.location

  tags = local.tags
}

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}