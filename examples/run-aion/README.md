## Run Spirent AION Platform

Run Spirent AION Platform.


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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_password | New cluster admin password. Specify using command line or env variables. | `any` | n/a | yes |
| aion\_password | AION password. Specify using command line or env variables. | `any` | n/a | yes |
| aion\_user | AION user. Specify using command line or env variables. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_public\_ips | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->