provider "azurerm" {
  features {}
}

module "vse_subscription_mover" {
  source = "../.."
  location = "westeurope"
  resource_group_name = "rg-SubscriptionMover-dev-01"
  function_name = "func-dev-SubscriptionMover-chhol-01"
  app_service_plan_name = "plan-dev-SubscriptionMover-chhol-01"
  
  storage_account_name = "stfunchholsubsmover01"

}