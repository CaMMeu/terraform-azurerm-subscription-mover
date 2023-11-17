provider "azurerm" {
  features {}
}

resource "azurerm_management_group" "source" {
  name = "Test-Source"
}

resource "azurerm_management_group" "target" {
  name = "Test-Target"
}

module "vse_subscription_mover" {
  source                    = "../.."
  location                  = "westeurope"
  resource_group_name       = "rg-SubMover-dev-01"
  function_app_name         = "func-dev-SubMover-test-01"
  app_service_plan_name     = "plan-dev-SubMover-test-01"
  storage_account_name      = "stfuntestsubmover01"
  application_insights_name = "appi-SubMover-dev-01"
  source_management_group   = azurerm_management_group.source
  target_management_group   = azurerm_management_group.target
}
