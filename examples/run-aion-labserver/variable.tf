variable "virtual_network_name" {
  description = "Virtual Network name in Azure."
  type        = string
  default     = "STCv"
}

variable "mgmt_subnet_name" {
  description = "Management subnet name."
  type        = string
  default     = "stcv-mgmt"
}

variable "instance_count" {
  description = "Number of instances to create."
  type        = number
  default     = 1
}

variable "instance_size" {
  description = "The Azure Virtual Machine SKU."
  type        = string
  default     = "Standard_F4s_v2"
}

variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
  default     = "default"
}

variable "resource_group_location" {
  type        = string
  description = "RG location in Azure"
  default     = "West US 2"
}

variable "admin_username" {
  description = "Administrator user name."
  type        = string
  default     = "azureuser"
}

variable "public_key" {
  description = "File path to public key."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key" {
  description = "File path to private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "aion_image_name" {
  description = "AION image created from private vhd file. This variable overrides the marketplace image."
  type        = string
  default     = ""
}

variable "marketplace_version" {
  description = "The Spirent AION image version (e.g. 0517.0.0). When not specified, the latest marketplace image will be used."
  type        = string
  default     = "latest"
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

variable "aion_url" {
  description = "AION URL"
  type        = string
  default     = "https://spirent.spirentaion.com"
}
