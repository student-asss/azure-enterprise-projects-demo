terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# RESOURCE GROUP (you can rename)
resource "azurerm_resource_group" "rg" {
  name     = "rg-s01-prod"
  location = var.location
}

# VNET
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# NSG
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# APP SERVICE PLAN
resource "azurerm_service_plan" "asp" {
  name                = var.asp_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

# APP SERVICE
resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      python_version = "3.13"
    }
  }
}

# LOG ANALYTICS
resource "azurerm_log_analytics_workspace" "law" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# APPLICATION INSIGHTS
resource "azurerm_application_insights" "appi" {
  name                = var.appinsights_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"
}

# ACTION GROUP
resource "azurerm_monitor_action_group" "ag" {
  name                = var.action_group_name
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "alerts"

  email_receiver {
    name          = "defaultEmail"
    email_address = var.alert_email
  }
}

# SMART DETECTOR
resource "azurerm_monitor_smart_detector_alert_rule" "smart" {
  name                = var.smart_detector_name
  resource_group_name = azurerm_resource_group.rg.name
  severity            = 3
  scope_resource_ids  = [azurerm_application_insights.appi.id]
  frequency           = "PT1M"
  detector_type       = "FailureAnomaliesDetector"

  action_group {
    action_group_id = azurerm_monitor_action_group.ag.id
  }
}

# METRIC ALERT
resource "azurerm_monitor_metric_alert" "metric" {
  name                = var.metric_alert_name
  resource_group_name = azurerm_resource_group.rg.name
  severity            = 3
  frequency           = "PT1M"
  window_size         = "PT5M"
  scopes              = [azurerm_linux_web_app.webapp.id]

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 100
  }
}

# NETWORK WATCHER
resource "azurerm_network_watcher" "nw" {
  name                = var.network_watcher_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}
