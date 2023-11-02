provider "azurerm" {
  features {}
}

module "vse_subscription_mover" {
  source = "../.."
  location = "westeurope"
  resource_group_name = "rg-SubMover-dev-01"
  function_name = "func-dev-SubMover-chhol-01"
  app_service_plan_name = "plan-dev-SubMover-chhol-01"
  storage_account_name = "stfunchholsubmover01"
  application_insights_name = "appi-SubMover-dev-01"
}