#VARIABLES

variable "instance_count" {
  description = "Number of instances to create."
  type        = number
  default     = 1
}

variable "instance_size" {
  description = "The Azure Virtual Machine SKU."
  type        = string
}

variable "instance_name" {
  description = "Name assigned to the AION instance.  An instance number will be appended to the name."
  type        = string
  default     = "aion"
}

variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "RG location in Azure"
}

variable "mgmt_plane_subnet_id" {
  description = "Management public Azure subnet ID."
  type        = string
}

variable "enable_provisioner" {
  description = "Enable provisioning.  When enabled instances will be initialized with the specified variables."
  type        = bool
  default     = true
}

variable "ingress_cidr_blocks" {
  description = "List of management interface ingress IPv4/IPv6 CIDR ranges."
  type        = list(string)
}

variable "aion_url" {
  description = "AION URL"
  type        = string
}

variable "aion_user" {
  description = "AION user registered on aion_url"
  type        = string
}

variable "aion_password" {
  description = "AION user password for aion_url"
  type        = string
}

variable "cluster_names" {
  description = "Instance cluster names.  List length must equal instance_count."
  type        = list(string)
  default     = []
}

variable "node_names" {
  description = "Instance cluster node names.  List length must equal instance_count."
  type        = list(string)
  default     = []
}

variable "admin_email" {
  description = "Cluster admin user email. Use this to login to instance web page.  Default is obtained from AION user information."
  type        = string
  default     = ""
}

variable "admin_password" {
  description = "Cluster admin user password. Use this to login to the instance web page."
  type        = string
}

variable "admin_first_name" {
  description = "Cluster admin user first name. Default is obtained from AION user information."
  type        = string
  default     = ""
}

variable "admin_last_name" {
  description = "Cluster admin user last name.  Default is obtained from AION user information."
  type        = string
  default     = ""
}

variable "local_admin_password" {
  description = "Cluster local admin password for instance SSH access.  Will use admin_password if not specified."
  type        = string
  default     = ""
}

variable "node_storage_provider" {
  description = "Cluster node storage provider"
  type        = string
  default     = "local"
}

variable "node_storage_remote_uri" {
  description = "Cluster node storage URI.  Leave blank for default when provider is local"
  type        = string
  default     = ""
}

variable "http_enabled" {
  description = "Allow HTTP access as well as HTTPS.  Normally this is not recommended."
  type        = bool
  default     = false
}

variable "metrics_opt_out" {
  description = "Opt-out of Spirent metrics data collection"
  type        = bool
  default     = false
}

variable "dest_dir" {
  description = "Destination directory on the instance where provisioning files will be copied"
  type        = string
  default     = "~"
}

variable "public_key" {
  description = "File path to public key."
  type        = string
}

variable "private_key" {
  description = "File path to private key"
  type        = string
}

variable "admin_username" {
  description = "Administrator user name."
  type        = string
}

variable "aion_image_name" {
  description = "AION image created from private vhd file"
  type        = string
}
