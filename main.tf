resource "azurerm_network_security_group" "mgmt_plane" {

  name                = "nsg-${var.instance_name}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.ingress_cidr_blocks
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefixes    = var.ingress_cidr_blocks
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = var.ingress_cidr_blocks
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "application-usage"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "64000-64999"
    source_address_prefixes    = var.ingress_cidr_blocks
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "application-usage2"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "49000-50000"
    source_address_prefixes    = var.ingress_cidr_blocks
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "icmp"
    priority                   = 106
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = var.ingress_cidr_blocks
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "aion" {
  count               = var.instance_count
  name                = "publicip-${var.instance_name}-${count.index}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "mgmt_plane" {
  count               = var.instance_count
  name                = "mgmt-nic-${var.instance_name}-${count.index}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipc-mgmt-${var.instance_name}-${count.index}"
    subnet_id                     = var.mgmt_plane_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.aion.*.id, count.index)
  }
}

resource "azurerm_network_interface_security_group_association" "mgmt_plane" {
  count                     = var.instance_count
  network_interface_id      = element(azurerm_network_interface.mgmt_plane.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.mgmt_plane.id
}

data "azurerm_image" "aion" {
  count               = var.aion_image_name != "" ? 1 : 0
  name                = var.aion_image_name
  resource_group_name = var.resource_group_name
}

data "template_file" "setup_aion" {
  count    = var.enable_provisioner ? var.instance_count : 0
  template = file("${path.module}/setup-aion.tpl")
  vars = {
    script_file             = "${var.dest_dir}/setup-aion.py"
    platform_addr           = azurerm_linux_virtual_machine.aion[count.index].public_ip_address
    aion_url                = var.aion_url
    aion_user               = var.aion_user
    aion_password           = var.aion_password
    cluster_name            = length(var.cluster_names) < 1 ? "" : var.cluster_names[count.index]
    node_name               = length(var.node_names) < 1 ? "" : var.node_names[count.index]
    admin_email             = var.admin_email
    admin_first_name        = var.admin_first_name
    admin_last_name         = var.admin_last_name
    admin_password          = var.admin_password
    local_admin_password    = var.local_admin_password
    node_storage_provider   = var.node_storage_provider
    node_storage_remote_uri = var.node_storage_remote_uri
    metrics_opt_out         = var.metrics_opt_out
    http_enabled            = var.http_enabled
    deploy_location         = var.deploy_location
    deploy_products         = jsonencode(var.deploy_products)
    entitlements            = jsonencode(var.entitlements)
  }
}

data "template_file" "release_aion" {
  count    = var.enable_provisioner ? var.instance_count : 0
  template = file("${path.module}/release-aion.tpl")
  vars = {
    script_file          = "${var.dest_dir}/release-aion.py"
    platform_addr        = azurerm_linux_virtual_machine.aion[count.index].public_ip_address
    aion_url             = var.aion_url
    aion_user            = var.aion_user
    aion_password        = var.aion_password
    admin_email          = var.admin_email
    admin_password       = var.admin_password
    local_admin_password = var.local_admin_password
  }
}

# Create AION VM
resource "azurerm_linux_virtual_machine" "aion" {
  count                 = var.instance_count
  name                  = "${var.instance_name}${count.index}"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [element(azurerm_network_interface.mgmt_plane.*.id, count.index)]
  size                  = var.instance_size
  admin_username        = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key)
  }

  os_disk {
    name                 = "osdisk-${var.instance_name}-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_id = var.aion_image_name != "" ? data.azurerm_image.aion[0].id : null
  dynamic "source_image_reference" {
    for_each = var.aion_image_name != "" ? [] : [1]
    content {
      publisher = "spirentcommunications1594084187199"
      offer     = "aion"
      sku       = "aion"
      version   = var.marketplace_version != "" ? var.marketplace_version : "latest"
    }
  }

  dynamic "plan" {
    for_each = var.aion_image_name != "" ? [] : [1]
    content {
      publisher = "spirentcommunications1594084187199"
      name      = "aion"
      product   = "aion"
    }
  }

}

# provision the AION VM
resource "null_resource" "provisioner" {
  count = var.enable_provisioner ? var.instance_count : 0
  triggers = {
    dest_dir       = var.dest_dir
    host           = azurerm_linux_virtual_machine.aion[count.index].public_ip_address
    private_key    = file(var.private_key)
    admin_username = var.admin_username
  }
  connection {
    host        = self.triggers.host
    type        = "ssh"
    user        = self.triggers.admin_username
    private_key = self.triggers.private_key
    agent       = false
  }

  # copy install script
  provisioner "file" {
    source      = "${path.module}/setup-aion.py"
    destination = "${var.dest_dir}/setup-aion.py"
  }

  provisioner "file" {
    content     = data.template_file.setup_aion[count.index].rendered
    destination = "${var.dest_dir}/setup-aion.sh"
  }

  provisioner "file" {
    source      = "${path.module}/release-aion.py"
    destination = "${var.dest_dir}/release-aion.py"
  }

  provisioner "file" {
    content     = data.template_file.release_aion[count.index].rendered
    destination = "${var.dest_dir}/release-aion.sh"
  }

  # run setup AION
  provisioner "remote-exec" {
    inline = [
      "bash ${var.dest_dir}/setup-aion.sh"
    ]
  }

  # destroy provisioner
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "bash ${self.triggers.dest_dir}/release-aion.sh"
    ]
  }
}
