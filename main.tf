provider "azurerm" {
  features {}
}

data "archive_file" "file_function_app" {
  type        = "zip"
  source_dir  = "${path.module}/AzFunction"
  output_path = "${path.module}/SubMover.zip"
}

data "azurerm_role_definition" "management_group_contributor" {
  name = "Management Group Contributor"
}

data "azurerm_role_definition" "user_access_administrator" {
  name = "User Access Administrator"
}

resource "azurerm_role_assignment" "source_uaa" {
  scope              = var.source_management_group.id
  role_definition_id = "${data.azurerm_role_definition.user_access_administrator.id}"
  principal_id       = azurerm_windows_function_app.function.identity[0].principal_id
}

resource "azurerm_role_assignment" "target_uaa" {
  scope              = var.target_management_group.id
  role_definition_id = "${data.azurerm_role_definition.user_access_administrator.id}"
  principal_id       = azurerm_windows_function_app.function.identity[0].principal_id
}

resource "azurerm_role_assignment" "source_mgmt_group_contributor" {
  scope              = var.source_management_group.id
  role_definition_id = "${data.azurerm_role_definition.management_group_contributor.id}"
  principal_id       = azurerm_windows_function_app.function.identity[0].principal_id
}

resource "azurerm_role_assignment" "target_mgmt_group_contributor" {
  scope              = var.target_management_group.id
  role_definition_id = "${data.azurerm_role_definition.management_group_contributor.id}"
  principal_id       = azurerm_windows_function_app.function.identity[0].principal_id
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "storage_container_function" {
  name                 = "function-upload"
  storage_account_name = azurerm_storage_account.sa.name
} 

resource "azurerm_storage_blob" "storage_blob_function" {
  name                   = "functions-SubMover.zip"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.storage_container_function.name
  type                   = "Block"
  source                 = data.archive_file.file_function_app.output_path
  content_md5 = data.archive_file.file_function_app.output_md5
}

resource "azurerm_role_assignment" "role_assignment_storage" {
  scope                            = azurerm_storage_account.sa.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = azurerm_windows_function_app.function.identity[0].principal_id
}

resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function" {
  name                       = var.function_app_name
  resource_group_name        = azurerm_resource_group.example.name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  //version                    = "~3"

  site_config {
    application_insights_key = azurerm_application_insights.appi.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.appi.connection_string
  }
  identity {
    type = "SystemAssigned"
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"       = azurerm_storage_blob.storage_blob_function.url
    "FUNCTIONS_WORKER_RUNTIME"       = "powershell"
    "source_management_group_name"   = var.source_management_group.name
    "target_management_group_name"   = var.target_management_group.name
    "FUNCTION_APP_EDIT_MODE" = "readonly"
  }

}

resource "azurerm_application_insights" "appi" {
  name                = var.application_insights_name
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = "web"
}