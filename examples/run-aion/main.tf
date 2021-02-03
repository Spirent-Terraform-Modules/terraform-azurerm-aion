provider "azurerm" {
  version                    = ">=2.37.0"
  skip_provider_registration = "true"
  features {}
}

data "azurerm_subnet" "mgmt_plane" {
  name                 = "stcv-mgmt"
  virtual_network_name = "STCv"
  resource_group_name  = "default"
}

module "aion" {
  source                    = "../.."

  instance_count            = 1
  instance_size             = "Standard_F4s_v2"
  resource_group_name       = "default"
  resource_group_location   = "West US 2"
  admin_username            = "azuretest"
  public_key                = "~/.ssh/id_rsa.pub"
  private_key_file          = "~/.ssh/id_rsa"
  mgmt_plane_subnet_id      = data.azurerm_subnet.mgmt_plane.id
  aion_image_name           = "newaionimage"
  aion_url                  = "https://spirent.spirentaion.com"
  aion_user                 = var.aion_user
  aion_password             = var.aion_password
  admin_password            = var.admin_password

  # Warning: Using all address cidr block to simplify the example. You should restrict addresses to your public network.
  ingress_cidr_blocks       = ["0.0.0.0/0"]
}

output "instance_public_ips" {
  value = module.aion.*.instance_public_ips
}

variable "admin_password" {
  description = "New cluster admin password. Specify using command line or env variables."
}

variable "aion_password" {
  description = "AION password. Specify using command line or env variables."
}

variable "aion_user" {
  description = "AION user. Specify using command line or env variables."
}

variable "virtual_network_name" {
  type        = string
  description = "VNET name in Azure"
  default     = ""
}

