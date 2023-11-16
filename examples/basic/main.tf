provider "azurerm" {
  features {}
}


data "azurerm_management_group" "source" {
  name = "CHHOL-New"
}

data "azurerm_management_group" "target" {
  name = "CHHOL-Sandbox"
}

module "vse_subscription_mover" {
  source = "../.."
  location = "westeurope"
  resource_group_name = "rg-SubMover-dev-02"
  function_app_name = "func-dev-SubMover-test-02"
  app_service_plan_name = "plan-dev-SubMover-test-02"
  storage_account_name = "stfunchholsubmover02"
  application_insights_name = "appi-SubMover-dev-02"
  source_management_group = data.azurerm_management_group.source
  target_management_group = data.azurerm_management_group.target
}
