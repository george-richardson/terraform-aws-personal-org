<!-- BEGIN_TF_DOCS -->
# Account Module

Creates an organization account with billing alarm and SCP if required.

> **Warning**
> By default deleting a module will also close the provisioned account. Use the `close_on_deletion` variable to change this behaviour.

## Examples

Minimal config:

```terraform
module "account" {
  source  = "george-richardson/personal-org/aws//modules/account"
  version = ">= 1.0.0"

  name  = "example"
  email = "example@example.org"
}
```

Create an account with a billing alarm that triggers at 20USD per month spending:

```terraform
module "account" {
  source  = "george-richardson/personal-org/aws//modules/account"
  version = ">= 1.0.0"

  name                    = "example"
  email                   = "example@example.org"
  billing_alarm_threshold = "20"
  billing_alarm_sns_topic = module.organization.billing_alarms_topic
}
```

Create an account with an SCP that only allows `t3.micro` instances to be created.

```terraform
module "account" {
  source  = "george-richardson/personal-org/aws//modules/account"
  version = ">= 1.0.0"

  name                     = "example"
  email                    = "example@example.org"
  allow_ec2_instance_types = ["t3.micro"]
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
| [aws_cloudwatch_metric_alarm.billing_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_organizations_account.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ec2_instance_types"></a> [allow\_ec2\_instance\_types](#input\_allow\_ec2\_instance\_types) | List of EC2 instance types to allow. If not set then all instance types are allowed. | `list(string)` | `[]` | no |
| <a name="input_allow_rds_instance_types"></a> [allow\_rds\_instance\_types](#input\_allow\_rds\_instance\_types) | List of RDS instance types to allow. If not set then all instance types are allowed. | `list(string)` | `[]` | no |
| <a name="input_allow_regions"></a> [allow\_regions](#input\_allow\_regions) | List of regions to allow AWS activity within. (Global services are ignored by this list) | `list(string)` | `[]` | no |
| <a name="input_allow_services"></a> [allow\_services](#input\_allow\_services) | List of services to allow API activity against. All other services will be blocked. Be careful about blocking IAM and other foundational services. When not set all services are allowed. | `list(string)` | `[]` | no |
| <a name="input_billing_alarm_sns_topic"></a> [billing\_alarm\_sns\_topic](#input\_billing\_alarm\_sns\_topic) | SNS topic to notify if this account breaches its spending threshold. If not set, then alarm will still be created but no action will be taken. | `string` | `""` | no |
| <a name="input_billing_alarm_threshold"></a> [billing\_alarm\_threshold](#input\_billing\_alarm\_threshold) | Threshold for monthly spending in USD to alert at. Omit or use value -1 to disable. | `number` | `-1` | no |
| <a name="input_block_root_user"></a> [block\_root\_user](#input\_block\_root\_user) | Should the root user have all access blocked? | `bool` | `false` | no |
| <a name="input_close_on_deletion"></a> [close\_on\_deletion](#input\_close\_on\_deletion) | Whether to close the account when deleted from the organization. | `bool` | `true` | no |
| <a name="input_email"></a> [email](#input\_email) | Email address to use for the new account. | `string` | n/a | yes |
| <a name="input_iam_user_access_to_billing"></a> [iam\_user\_access\_to\_billing](#input\_iam\_user\_access\_to\_billing) | Allow IAM resources access to billing. Valid values are 'ALLOW' or 'DENY', by default a null value will match to 'ALLOW'. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Alias for the account. | `string` | n/a | yes |
| <a name="input_override_policy_documents"></a> [override\_policy\_documents](#input\_override\_policy\_documents) | List of JSON SCP policy documents that will be merged with the generated SCP. | `list(string)` | `[]` | no |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | ID of the organizational unit this account should be a part of. | `string` | `null` | no |
| <a name="input_protected_iam_resources"></a> [protected\_iam\_resources](#input\_protected\_iam\_resources) | List of IAM ARNs which will be protected from modification by all users. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the account. |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the OrganizationAccountAccessRole for this account. |
<!-- END_TF_DOCS -->