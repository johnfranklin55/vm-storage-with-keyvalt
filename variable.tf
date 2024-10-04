variable "azurerm_virtual_network" {
  type = string
  default = "johnfranklin_vnet"
  description = "name of the vnet"
  
}

variable "address_space" {
  type = list(string)
  default = ["10.0.0.0/16"]
  description = "address space for the vnet"
}

variable "azurerm_subnet" {
  type = string
  default = "subnetsd"
  description = "name of the subnet"
}

variable "address_prefixes" {
  type = list(string)
  default = ["10.0.0.0/20"]
  description = "address prefix for the subnet"
  
}

variable "azurerm_network_interface" {
  type = string
  default = "johnfranklin_nic"
  description = "virtual nework"
    
}

variable "azurerm_key_vault" {
  type = string
  default = "franklin-kv"
  description = "key vault"
    
}

variable "azurerm_storage_account" {
  type = string
  default = "johnsd"
  description = "storage"
    
}

variable "azurerm_windows_virtual_machine" {
  type = string
  default = "johnfranklin-vm"
  description = "virtual machine name"
}

variable "admin_username" {
  type = string
  description = "user name of the virtual machine"
}

variable "admin_password" {
  type = string
  description = "user name password for the virtual machine"
}

