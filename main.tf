terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.54.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.38.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}

provider "azuread" {
  # Configuration options
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"

  provisioner "local-exec" {
    command = "az acr login -n ${var.acr_name}"
  }

  provisioner "local-exec" {
    command = "docker push ${var.acr_name}.azurecr.io/tools/azurenamingtool"
  }

}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
}

resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = var.managed_identity_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_storage_account" "sta" {
  name                     = var.storage_account_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_share" "share1" {
  name                 = "share1"
  storage_account_name = azurerm_storage_account.sta.name
  quota                = 5
}
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.name}.azurecr.io/tools/azurenamingtool"
      docker_image_tag = "latest"

    }
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.managed_identity.client_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.managed_identity.id]
  }

  storage_account {
    access_key   = azurerm_storage_account.sta.primary_access_key
    account_name = azurerm_storage_account.sta.name
    name         = "mount1"
    type         = "AzureFiles"
    mount_path   = "/app/settings"
    share_name   = azurerm_storage_share.share1.name
  }

  depends_on = [azurerm_role_assignment.role_assignment]
}

