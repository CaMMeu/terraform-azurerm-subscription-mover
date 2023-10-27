provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.example.name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  //allow_blob_public_access  = false
  enable_https_traffic_only = true
}

resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  os_type = "Windows"
  sku_name = "Y1"
}



resource "azurerm_windows_function_app" "function" {
  name                       = var.function_name
  resource_group_name        = azurerm_resource_group.example.name
  location                   = var.location
  service_plan_id        = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  //version                    = "~3"

  site_config {}
  
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = "powershell"
    "FUNCTIONS_WORKER_RUNTIME_VERSION" = "~7"
  }
  
}
