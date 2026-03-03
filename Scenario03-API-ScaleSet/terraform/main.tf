terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source   = "./modules/network"
  location = var.location
}

module "loadbalancer" {
  source     = "./modules/loadbalancer"
  location   = var.location
  subnet_id  = module.network.backend_subnet_id
}

module "vmss" {
  source          = "./modules/vmss"
  location        = var.location
  admin_username  = var.admin_username
  admin_password  = var.admin_password
  subnet_id       = module.network.backend_subnet_id
  backend_pool_id = module.loadbalancer.backend_pool_id
}

module "autoscale" {
  source   = "./modules/autoscale"
  location = var.location
  vmss_id  = module.vmss.vmss_id
}
