//  https://azure.microsoft.com/en-ca/global-infrastructure/geographies/
variable "location" {
  description = "Name of the location where the resources will be provisioned"
  type = string
}

variable "source_management_group" {
  description = "The source management group"
  type = object({
    name = string
    id = string
  })
}

variable "target_management_group" {
  description = "The target management group"
  type = object({
    name = string
    id = string
  })
}


variable "resource_group_name" {
  description = "Name of the resource group"
  type = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type = string
}

variable "app_service_plan_name" {
  description = "Name of the application service plan"
  type = string
}

variable "function_app_name" {
  description = "Name of the function"
  type = string
}

variable "application_insights_name" {
  description = "Name of the Application Insights"
  type = string
}