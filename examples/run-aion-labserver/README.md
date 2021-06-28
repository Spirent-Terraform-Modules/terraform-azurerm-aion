## Run Spirent AION Platform

Run Spirent AION Platform.

## Usage

To run this example you need to execute:

    $ terraform init
    $ terraform plan
    $ terraform apply

This example will create resources that will incur a cost. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| aion | ../.. |  |

## Resources

| Name |
|------|
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_password | New cluster admin password. Specify using command line or env variables. | `any` | n/a | yes |
| admin\_username | Administrator user name. | `string` | `"azureuser"` | no |
| aion\_image\_name | AION image created from private vhd file. This variable overrides the marketplace image. | `string` | `""` | no |
| aion\_password | AION password. Specify using command line or env variables. | `any` | n/a | yes |
| aion\_url | AION URL | `string` | `"https://spirent.spirentaion.com"` | no |
| aion\_user | AION user. Specify using command line or env variables. | `any` | n/a | yes |
| instance\_count | Number of instances to create. | `number` | `1` | no |
| instance\_size | The Azure Virtual Machine SKU. | `string` | `"Standard_F4s_v2"` | no |
| marketplace\_version | The Spirent AION image version (e.g. 0517.0.0). When not specified, the latest marketplace image will be used. | `string` | `"latest"` | no |
| mgmt\_subnet\_name | Management subnet name. | `string` | `"stcv-mgmt"` | no |
| private\_key | File path to private key | `string` | `"~/.ssh/id_rsa"` | no |
| public\_key | File path to public key. | `string` | `"~/.ssh/id_rsa.pub"` | no |
| resource\_group\_location | RG location in Azure | `string` | `"West US 2"` | no |
| resource\_group\_name | RG name in Azure | `string` | `"default"` | no |
| virtual\_network\_name | Virtual Network name in Azure. | `string` | `"STCv"` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_public\_ips | List of public IP addresses assigned to the instances, if applicable |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
