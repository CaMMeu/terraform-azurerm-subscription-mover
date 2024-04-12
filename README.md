# Azure VSE Subscription Mover
[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-azurerm-subscription-mover.svg)](https://registry.terraform.io/modules/qbeyond/subscription-mover/azurerm/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-azurerm-subscription-mover.svg)](https://github.com/qbeyond/terraform-azurerm-subscription-mover/blob/main/LICENSE)

----
## Description
This module deploys an Azure Function App with a Function, which moves every VSE Subscription from a source management group to a target management group, based on the Quota ID MSDN_2014_09_01.
The function runs every 5 minutes.

<!-- BEGIN_TF_DOCS -->
## Usage

To use this module, the source and target Management Groups you want to use for Subscription moving are required. 
The Management Groups are recommended to have the same display name as the ID for ease of use.

Only the main.tf needs to be run to deploy the function app with the function, which will run immediately.

```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_plan_name"></a> [app\_service\_plan\_name](#input\_app\_service\_plan\_name) | Name of the application service plan used for the Azure Function App. | `string` | n/a | yes |
| <a name="input_application_insights_name"></a> [application\_insights\_name](#input\_application\_insights\_name) | Name of the Application Insights, which will show Monitoring information of the Azure Function App. | `string` | n/a | yes |
| <a name="input_function_app_name"></a> [function\_app\_name](#input\_function\_app\_name) | Name of the Azure Function App in which the function will be deployed. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Name of the location where the resources will be provisioned. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group in which to create the resources. Changing this forces new resources to be created. | `string` | n/a | yes |
| <a name="input_source_management_group"></a> [source\_management\_group](#input\_source\_management\_group) | The source management group from which the Subscriptions will be moved from. The name used here is not the display name, it is the ID shown next to the display name in the Azure Portal Management Group view. | <pre>object({<br>    name = string<br>    id   = string<br>  })</pre> | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of the storage account used for the Azure Function App. | `string` | n/a | yes |
| <a name="input_target_management_group"></a> [target\_management\_group](#input\_target\_management\_group) | The target management group to which the subscriptions will be moved. The name used here is not the display name, it is the ID shown next to the display name in the Azure Portal Management Group view. | <pre>object({<br>    name = string<br>    id   = string<br>  })</pre> | n/a | yes |
## Outputs

No outputs.

      ## Resource types

      | Type | Used |
      |------|-------|
        | [azurerm_application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | 1 |
        | [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | 1 |
        | [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | 3 |
        | [azurerm_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | 1 |
        | [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | 1 |
        | [azurerm_storage_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | 1 |
        | [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | 1 |
        | [azurerm_windows_function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | 1 |

      **`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.
    
## Modules

No modules.

        ## Resources by Files

            ### main.tf

            | Name | Type |
            |------|------|
                  | [azurerm_application_insights.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
                  | [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
                  | [azurerm_role_assignment.role_assignment_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_role_assignment.source_mgmt_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_role_assignment.target_mgmt_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
                  | [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
                  | [azurerm_storage_blob.storage_blob_function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
                  | [azurerm_storage_container.storage_container_function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
                  | [azurerm_windows_function_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
                  | [archive_file.file_function_app](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
                  | [azurerm_role_definition.management_group_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
                  | [azurerm_role_definition.user_access_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
    
<!-- END_TF_DOCS -->

## Contribute

Please use Pull requests to contribute.

When a new Feature or Fix is ready to be released, create a new Github release and adhere to [Semantic Versioning 2.0.0](https://semver.org/lang/de/spec/v2.0.0.html).