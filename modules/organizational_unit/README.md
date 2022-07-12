<!-- BEGIN_TF_DOCS -->
# Organizational Unit Module

Creates an organizational unit with SCP if required.

## Examples

Minimal configuration:

```terraform
module "organizational_unit" {
  source  = "george-richardson/personal-org/aws//modules/organizational_unit"
  version = ">= 1.0.0"

  name      = "example"
  parent_id = module.organization.root_organizational_unit
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.22.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_scp"></a> [scp](#module\_scp) | ../scp | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organizational_unit.ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ec2_instance_types"></a> [allow\_ec2\_instance\_types](#input\_allow\_ec2\_instance\_types) | List of EC2 instance types to allow. If not set then all instance types are allowed. | `list(string)` | `[]` | no |
| <a name="input_allow_rds_instance_types"></a> [allow\_rds\_instance\_types](#input\_allow\_rds\_instance\_types) | List of RDS instance types to allow. If not set then all instance types are allowed. | `list(string)` | `[]` | no |
| <a name="input_allow_regions"></a> [allow\_regions](#input\_allow\_regions) | List of regions to allow AWS activity within. (Global services are ignored by this list) | `list(string)` | `[]` | no |
| <a name="input_allow_services"></a> [allow\_services](#input\_allow\_services) | List of services to allow API activity against. All other services will be blocked. Be careful about blocking IAM and other foundational services. When not set all services are allowed. | `list(string)` | `[]` | no |
| <a name="input_block_root_user"></a> [block\_root\_user](#input\_block\_root\_user) | Should the root user have all access blocked? | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Alias for the account. | `string` | n/a | yes |
| <a name="input_override_policy_documents"></a> [override\_policy\_documents](#input\_override\_policy\_documents) | List of JSON SCP policy documents that will be merged with the generated SCP. | `list(string)` | `[]` | no |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | ID of the organizational unit this organizational unity should be a child of. | `string` | n/a | yes |
| <a name="input_protected_iam_resources"></a> [protected\_iam\_resources](#input\_protected\_iam\_resources) | List of IAM ARNs which will be protected from modification by all users. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the organizational unit. |
<!-- END_TF_DOCS -->