provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "random" {}

terraform {
  required_version = ">= 1.6.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.96.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }
  }
}
