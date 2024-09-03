terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      
    }
  }
}
 
provider "azurerm" {
    
  features {
   
  }
}

# Resource Group
resource "azurerm_resource_group" "demo-rg" {
  name     = "demo-resources-group"
  location = "East US"
}

resource "azurerm_service_plan" "webapp-plan" {
  name                = "webapp-plan"
  resource_group_name = azurerm_resource_group.demo-rg.name
  location            = azurerm_resource_group.demo-rg.location
  sku_name            = "S1"
  os_type             = "Windows"
  depends_on = [ azurerm_resource_group.demo-rg ]
 
}
 
resource "azurerm_windows_web_app" "webapp" {
  name                = "webappperonaltest"
  resource_group_name = azurerm_resource_group.demo-rg.name
  location            = azurerm_resource_group.demo-rg.location
  service_plan_id     = azurerm_service_plan.webapp-plan.id
  depends_on = [ azurerm_resource_group.demo-rg,azurerm_service_plan.webapp-plan ]
 
  site_config {
  }
  https_only = true
}
  resource "azurerm_app_service_source_control" "github" {
  app_id = azurerm_windows_web_app.webapp.id
  repo_url = "https://github.com/ahtashamalam7/webapp"
  branch   = "main"  
 
}
resource "azurerm_windows_web_app_slot" "Testing" {
    name = "Testing"
   
    app_service_id = azurerm_windows_web_app.webapp.id
    site_config {
       
    }
 
   
}







