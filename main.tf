terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "d055dd42-c99f-4996-a41c-c5eeaae843f3"
  features {}
}

# Resource Group
resource "azurerm_resource_group" "demo-rg" {
  name     = "demo-resources-group"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "demo-vn" {
  name                = "demo-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name
}

# Subnet
resource "azurerm_subnet" "demo-subnet" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.demo-rg.name
  virtual_network_name = azurerm_virtual_network.demo-vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Public IP
resource "azurerm_public_ip" "demo-ip" {
  name                = "demo-public-ip"
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name
  allocation_method   = "Dynamic"
}

# Network Interface
resource "azurerm_network_interface" "demo-nic" {
  name                = "demo-nic"
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo-ip.id
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "demo-vm" {
  name                  = "demo-azure-vm"
  location              = azurerm_resource_group.demo-rg.location
  resource_group_name   = azurerm_resource_group.demo-rg.name
  network_interface_ids = [azurerm_network_interface.demo-nic.id]
  size                  = "Standard_DS1_v2"

  admin_username = "alam"
  admin_password = "Ahtashamalam@123" # Replace with your own password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "alam"
  disable_password_authentication = false
}

# Output Public IP
output "public_ip_address" {
  value = azurerm_public_ip.demo-ip.ip_address
}
