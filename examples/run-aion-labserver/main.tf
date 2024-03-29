provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

data "azurerm_subnet" "mgmt_plane" {
  name                 = var.mgmt_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

module "aion" {
  source = "../.."

  marketplace_version     = var.marketplace_version
  aion_image_name         = var.aion_image_name
  instance_size           = var.instance_size
  instance_count          = var.instance_count
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  mgmt_plane_subnet_id    = data.azurerm_subnet.mgmt_plane.id
  # Warning: Using all address cidr block to simplify the example. You should restrict addresses to your public network.
  ingress_cidr_blocks = ["0.0.0.0/0"]

  public_key  = var.public_key
  private_key = var.private_key

  aion_url       = var.aion_url
  aion_user      = var.aion_user
  aion_password  = var.aion_password
  admin_username = var.admin_username
  admin_password = var.admin_password
  http_enabled   = true

  os_disk_size_gb = 60

  deploy_location = "labserver"
  deploy_products = [
    {
      name    = "STC LabServer"
      version = "5.20.0032"
    }
  ]

  entitlements = [
    {
      product = "Spirent TestCenter"
      license = "Virtual High Scale Bandwidth"
      number  = 1000
    },
    {
      product = "Spirent TestCenter"
      license = "Access"
      number  = 100
    }
  ]
}

output "instance_public_ips" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = module.aion.*.instance_public_ips
}
