# Comment
terraform {
  required_version = ">= 0.11.1"
}

variable "location" {
  description = "Azure location in which to create resources"
  default = "East US"
}

variable "windows_dns_prefix" {
  description = "DNS prefix to add to to public IP address for Windows VM"
}

variable "admin_password" {
  description = "admin password for Windows VM"
  default = "pTFE123!"
}

module "windowsserver" {
  source              = "Azure/compute/azurerm"
  version             = "1.1.5"
  location            = "${var.location}"
  vm_hostname         = "chad-ptfe-1"
  admin_password      = "${var.admin_password}"
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = ["${var.windows_dns_prefix}"]
  vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
}

module "network" {
  source              = "Azure/network/azurerm"
  version             = "1.1.1"
  location            = "${var.location}"
  resource_group_name = "terraform-compute"
  allow_ssh_traffic   = true
}

output "windows_vm_public_name"{
  value = "${module.windowsserver.public_ip_dns_name}"
}
