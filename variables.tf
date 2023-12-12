//  https://azure.microsoft.com/en-ca/global-infrastructure/geographies/
variable "location" {
  description = "Name of the location where the resources will be provisioned."
  type        = string
}

variable "source_management_group" {
  description = "The source management group from which the Subscriptions will be moved from. The name used here is not the display name, it is the ID shown next to the display name in the Azure Portal Management Group view."
  type = object({
    name = string
    id   = string
  })

  # if the input for the name is incorrect, the default error is explanatory enough
}

variable "target_management_group" {
  description = "The target management group to which the subscriptions will be moved. The name used here is not the display name, it is the ID shown next to the display name in the Azure Portal Management Group view."
  type = object({
    name = string
    id   = string
  })

  # if the input for the name is incorrect, the default error is explanatory enough
}

variable "resource_group_name" {
  description = "Name of the resource group in which to create the resources. Changing this forces new resources to be created."
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account used for the Azure Function App."
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the application service plan used for the Azure Function App."
  type        = string
}

variable "function_app_name" {
  description = "Name of the Azure Function App in which the function will be deployed."
  type        = string
}

variable "application_insights_name" {
  description = "Name of the Application Insights, which will show Monitoring information of the Azure Function App."
  type        = string
}
