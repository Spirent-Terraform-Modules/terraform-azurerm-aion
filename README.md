# Azure RM Spirent AION Platform Terraform

![Image of Spirent AION](./images/aion.jpg)

## Description
[Spirent AION](https://www.spirent.com/products/aion) is a cloud platform for Spirent products and license management.
This Terraform module deploys the [Spirent AION Azure Image](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/spirentcommunications1594084187199.aion?tab=overview) on Azure using your spirentaion.com account.

After `terraform apply` finishes you will be able to point your browser at the `instance_public_ips` addresses to use the platform or perform additional configuration.

Set `enable_provisioner=false` to run the configuration wizard manually in a web browser.  Otherwise, when `enable_provisioner=true` login to https://<your_public_ip> using the values of `admin_email` and `admin_password`.

See [product configuration](#product-configuration) for automated and manual configuration details.

## Prerequisites
- Azure user credentials (az login)
- Accept [Spirent AION Image](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/spirentcommunications1594084187199.aion?tab=overview) product terms on Azure Marketplace
  - `az vm image list --all --publisher spirentcommunications1594084187199  --offer aion`
  - `az vm image terms accept --urn <selected_urn>`
- Create public and private key files

## Terraform examples
Terraform examples are located in the [examples](./examples) folder.

### Basic usage
```
module "aion" {
  source = "git::https://github.com/Spirent-Terraform-Modules/terraform-azurerm-aion"

  resource_group_name     = "default"
  resource_group_location = "West US 2"
  mgmt_plane_subnet_id    =  "subnet-id-123456"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  public_key  = "./bootstrap_public_key_file"
  private_key = "./bootstrap_private_key_file"

  aion_url       = "https://spirent.spirentaion.com"
  aion_user      = "user1@spirent.com"
  aion_password  = "aion-password"
  admin_password = "admin-password"
}
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| azurerm | >=2.37.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >=2.37.0 |
| null | n/a |
| template | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azurerm_image](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/image) |
| [azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) |
| [azurerm_network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) |
| [azurerm_network_interface_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) |
| [azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_email | Cluster admin user email. Use this to login to instance web page.  Default is obtained from AION user information. | `string` | `""` | no |
| admin\_first\_name | Cluster admin user first name. Default is obtained from AION user information. | `string` | `""` | no |
| admin\_last\_name | Cluster admin user last name.  Default is obtained from AION user information. | `string` | `""` | no |
| admin\_password | Cluster admin user password. Use this to login to the instance web page. | `string` | n/a | yes |
| admin\_username | Administrator user name. | `string` | n/a | yes |
| aion\_image\_name | AION image created from private vhd file.  This variable overrides the marketplace image. | `string` | `""` | no |
| aion\_password | AION user password for aion\_url | `string` | n/a | yes |
| aion\_url | AION URL | `string` | n/a | yes |
| aion\_user | AION user registered on aion\_url | `string` | n/a | yes |
| cluster\_names | Instance cluster names.  List length must equal instance\_count. | `list(string)` | `[]` | no |
| deploy\_location | Location name for deployed product instances. | `string` | `"location1"` | no |
| deploy\_products | List of products to deploy. See Product List below for details. | `list(map(string))` | `[]` | no |
| dest\_dir | Destination directory on the instance where provisioning files will be copied | `string` | `"~"` | no |
| enable\_provisioner | Enable provisioning.  When enabled instances will be initialized with the specified variables. | `bool` | `true` | no |
| entitlements | Install hosted entitlements from organization's AION platform. See Entitlement List below for details. | `list(map(string))` | `[]` | no |
| http\_enabled | Allow HTTP access as well as HTTPS.  Normally this is not recommended. | `bool` | `false` | no |
| ingress\_cidr\_blocks | List of management interface ingress IPv4/IPv6 CIDR ranges. | `list(string)` | n/a | yes |
| instance\_count | Number of instances to create. | `number` | `1` | no |
| instance\_name | Name assigned to the AION instance.  An instance number will be appended to the name. | `string` | `"aion"` | no |
| instance\_size | The Azure Virtual Machine SKU. | `string` | n/a | yes |
| local\_admin\_password | Cluster local admin password for instance SSH access.  Will use admin\_password if not specified. | `string` | `""` | no |
| marketplace\_version | The Spirent AION image version (e.g. 0517.0.0). When not specified, the latest marketplace image will be used. | `string` | `"latest"` | no |
| metrics\_opt\_out | Opt-out of Spirent metrics data collection | `bool` | `false` | no |
| mgmt\_plane\_subnet\_id | Management public Azure subnet ID. | `string` | n/a | yes |
| node\_names | Instance cluster node names.  List length must equal instance\_count. | `list(string)` | `[]` | no |
| node\_storage\_provider | Cluster node storage provider | `string` | `"local"` | no |
| node\_storage\_remote\_uri | Cluster node storage URI.  Leave blank for default when provider is local | `string` | `""` | no |
| os\_disk\_size\_gb | Size of the OS disk in GB. When null size will be determined from the image. | `number` | `null` | no |
| private\_key | File path to private key | `string` | n/a | yes |
| public\_key | File path to public key. | `string` | n/a | yes |
| resource\_group\_location | RG location in Azure | `string` | n/a | yes |
| resource\_group\_name | RG name in Azure | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_ids | List of instance IDs |
| instance\_private\_ips | List of private IP addresses assigned to the instances, if applicable |
| instance\_public\_ips | List of public IP addresses assigned to the instances, if applicable |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Product Configuration
Product configuration specifies product deployment and license entitlements for the platform.

### Automated
Use Terraform variables for automated configuration.

#### Entitlement List
The entitlement list specifies which license entitlements are hosted to the new AION platform.  An empty list will not add entitlements.  Use the following options to define each entitlement:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| product | Product name | `string` | n/a | yes |
| license | License name | `string` | n/a | yes |
| number  | Entitlement number.  When specified number must match otherwise any will match.| `number` | n/a | no |

#### Product List
The product list specifies which products will be deployed.  An empty list will not deploy any products.  Use the following options to define each product deployment:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Product name | `string` | n/a | yes |
| version | Product version | `string` | n/a | yes |


### Manual
Use the web browser to perform additional manual configuration after the intance is deployed.

#### Add License Entitlements
1. From _Settings_ <img src="./images/aion_settings.jpg" width="22" height="22"/> navigate to _License Manager_, _Entitlements_
2. Click _Install Entitlements_
3. Use one of the following methods to add entitlements (#1 is prefered)
   1. Login to <your_org>.spirentaion.com and select entitlements to host in the new instance\
      **Note:** Hosted entitlements should be released before destroying the instance.  As a convenience `terraform destroy` will unhost remaining entitlements.  However, if instance state is manually manipulated you may need to contact Spirent support to release entitlements for you.
   2. Install a license entitlement file obtained from Spirent support

#### Add Products
1. From _Settings_ <img src="./images/aion_settings.jpg" width="22" height="22"/> navigate to _Settings_, _Add New Products_
2. Click _Install New Products_
3. Select products and versions and click _Install_
