data "azurerm_resource_group" "john-franklin" {
  name = "john-franklin"
}

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "franklin-kv" {
  name                        = var.azurerm_key_vault
  location                    = data.azurerm_resource_group.john-franklin.location
  resource_group_name         = data.azurerm_resource_group.john-franklin.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_storage_account" "johnsd" {
  name                      = var.azurerm_storage_account
  location                  = data.azurerm_resource_group.john-franklin.location
  resource_group_name       = data.azurerm_resource_group.john-franklin.name
  account_tier              = "Standard"
  account_replication_type  = "GRS"

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
}


resource "azurerm_virtual_network" "johnfranklin_vnet" {
  name                = var.azurerm_virtual_network
  address_space       = var.address_space
  location            = data.azurerm_resource_group.john-franklin.location
  resource_group_name = data.azurerm_resource_group.john-franklin.name
}

resource "azurerm_subnet" "subnetsd" {
  name                 = var.azurerm_subnet
  resource_group_name  = data.azurerm_resource_group.john-franklin.name
  virtual_network_name = var.azurerm_virtual_network
  address_prefixes     = var.address_prefixes
}

resource "azurerm_network_interface" "johnfranklin_nic" {
  name                = var.azurerm_network_interface
  location            = data.azurerm_resource_group.john-franklin.location
  resource_group_name = data.azurerm_resource_group.john-franklin.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     =  azurerm_subnet.subnetsd.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "johnfranklin-vm" {
  name                = var.azurerm_windows_virtual_machine
  resource_group_name = data.azurerm_resource_group.john-franklin.name
  location            = data.azurerm_resource_group.john-franklin.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.johnfranklin_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}