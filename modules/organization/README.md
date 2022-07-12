<!-- BEGIN_TF_DOCS -->
# Organization Module

Creates an AWS organization and SNS topic for billing alarms.
By default this module also attaches an SCP to the root of the organization that prevents use of root accounts and modification of the `OrganizationAccountAccessRole` role.

## Examples

Minimal configuration:

```terraform
module "organization" {
  source  = "george-richardson/personal-org/aws//modules/organization"
  version = ">= 1.0.0"
}
```

Add an email subscription to the billing alarms SNS topic:
```terraform
module "organization" {
  source  = "george-richardson/personal-org/aws//modules/organization"
  version = ">= 1.0.0"

  billing_alarms_email_subscribers = ["george@example.org"]
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
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_sns_topic.billing_alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.billing_alarms_emails](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ec2_instance_types"></a> [allow\_ec2\_instance\_types](#input\_allow\_ec2\_instance\_types) | List of EC2 instance types to allow. If not set then all instance types are allowed. | `list(string)` | `[]` | no |
| <a name="input_allow_rds_instance_types"></a> [allow\_rds\_instance\_types](#input\_allow\_rds\_instance\_types) | List of RDS instance types to allow. If not set then all instance types are allowed. | `list(string)` | `[]` | no |
| <a name="input_allow_regions"></a> [allow\_regions](#input\_allow\_regions) | List of regions to allow AWS activity within. (Global services are ignored by this list) | `list(string)` | `[]` | no |
| <a name="input_allow_services"></a> [allow\_services](#input\_allow\_services) | List of services to allow API activity against. All other services will be blocked. Be careful about blocking IAM and other foundational services. When not set all services are allowed. | `list(string)` | `[]` | no |
| <a name="input_aws_service_access_principals"></a> [aws\_service\_access\_principals](#input\_aws\_service\_access\_principals) | List of AWS service principal names for which you want to enable integration with your organization. | `list(string)` | `[]` | no |
| <a name="input_billing_alarms_email_subscribers"></a> [billing\_alarms\_email\_subscribers](#input\_billing\_alarms\_email\_subscribers) | List of emails to subscribe to billing alarms. | `list(string)` | `[]` | no |
| <a name="input_billing_alarms_topic_name"></a> [billing\_alarms\_topic\_name](#input\_billing\_alarms\_topic\_name) | Name to use for the billing alarms topic. | `string` | `"billing-alarms"` | no |
| <a name="input_block_organization_role_modification"></a> [block\_organization\_role\_modification](#input\_block\_organization\_role\_modification) | Should modification of OrganizationAccountAccessRole in child accounts be blocked? | `bool` | `true` | no |
| <a name="input_block_root_user"></a> [block\_root\_user](#input\_block\_root\_user) | Should the root user have all access blocked? | `bool` | `true` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | List of Organizations policy types to enable in the Organization Root. | `list(string)` | <pre>[<br>  "SERVICE_CONTROL_POLICY"<br>]</pre> | no |
| <a name="input_override_policy_documents"></a> [override\_policy\_documents](#input\_override\_policy\_documents) | List of JSON SCP policy documents that will be merged with the generated SCP. | `list(string)` | `[]` | no |
| <a name="input_protected_iam_resources"></a> [protected\_iam\_resources](#input\_protected\_iam\_resources) | List of IAM ARNs which will be protected from modification by all users. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_billing_alarms_topic"></a> [billing\_alarms\_topic](#output\_billing\_alarms\_topic) | ARN of the billing alarms SNS topic. |
| <a name="output_root_organizational_unit"></a> [root\_organizational\_unit](#output\_root\_organizational\_unit) | ID of the root organizational unit of the organization. |
<!-- END_TF_DOCS -->