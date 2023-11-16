# Azure VSE Subscription Mover
[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-azurerm-subscription-mover.svg)](https://registry.terraform.io/modules/qbeyond/subscription-mover/azurerm/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-azurerm-subscription-mover.svg)](https://github.com/qbeyond/terraform-azurerm-subscription-mover/blob/main/LICENSE)

----
## Description
This module deploys an Azure Function App with a Function, which moves every VSE Subscription from a source management group to a target management group, based on the Quota ID MSDN_2014_09_01.
The function runs every 5 minutes.

<!-- BEGIN_TF_DOCS -->
## Usage

It's very easy to use!
```hcl
provider "azurerm" {
  features {

  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Inputs

No inputs.
## Outputs

No outputs.
## Resource types

No resources.


## Modules

No modules.
## Resources by Files

No resources.

<!-- END_TF_DOCS -->

## Contribute

Please use Pull requests to contribute.

When a new Feature or Fix is ready to be released, create a new Github release and adhere to [Semantic Versioning 2.0.0](https://semver.org/lang/de/spec/v2.0.0.html).