# personal-org Modules

A set of modules that make running a single user AWS Organization easier.

## Overview

### Features

* Single user entry point for all child accounts.
  * Default deployed OrganizationAccountAccessRole is used for assumption by a organization administrator user into child accounts.
  * Child account OrganizationAccountAccessRoles are protected from deletion (by default).
  * Child account root user access is blocked (by default).
  * MFA must be used to access child accounts (from bootstrap template).
* Separate Organization management role (from bootstrap template).
  * Limited access to management account to manage the Organization and save Terraform state.
  * Must be explicitly assumed.
* Billing alarms can easily be applied to accounts with notification via an SNS topic.
* Limit organizational units or accounts to specific services or regions.
* Limit the EC2/RDS instance types that can be used in an account or organizational unit.

### When to use these modules

* You are an individual.
* You want to run multiple AWS accounts but maintain an easy way to access them without juggling credentials.
* You are concerned with AWS billing and want an easy way to configure billing alerts.
* You want simple, coarse tools to limit the usage of accounts.
* Your prime concern if an AWS account is compromised is that an attacker may spend your money.
* In general, you want to spend as little money as possible.

### When not to use these modules: 

* Your AWS Organization will have multiple users.
* Your prime concern if an AWS account is compromised is that data is not accessed or leaked.
* You want granular management over child account permissions. 
* You need visibility over your Organization for compliance reasons.

If any of the above are true then consider using more robust solutions from AWS 
such as [Control Tower](https://aws.amazon.com/controltower/).

## Basic Usage

Before using for the first time take a look at the bootstrapping section below. 

> **Warning**
> For billing alarms to work these modules must be deployed to the `us-east-1` region.

### Creating an Organization

This is the minimal config to create an Organization.

```terraform
module "organization" {
  source  = "george-richardson/personal-org/aws//modules/organization"
  version = ">= 1.0.0"
}
```

This config limits the entire Organization to only allow actions in the eu-west-1 region and adds an email subscriber for the billing alarms topic.

```terraform
module "organization" {
  source  = "george-richardson/personal-org/aws//modules/organization"
  version = ">= 1.0.0"

  allow_regions                    = [ "eu-west-1" ]
  billing_alarms_email_subscribers = ["george@example.org"]
}
```

[See more](./modules/organization/README.md).

### Creating an Organizational Unit

This is the minimal config to create an Organizational Unit.

```terraform
module "organization" {
  source  = "george-richardson/personal-org/aws//modules/organization"
  version = ">= 1.0.0"
}

module "organizational_unit" {
  source  = "george-richardson/personal-org/aws//modules/organizational_unit"
  version = ">= 1.0.0"

  name      = "example"
  parent_id = module.organization.root_organizational_unit
}
```

This config limits the OU to only allow actions for the IAM and S3 services. 

```terraform
module "organizational_unit" {
  source  = "george-richardson/personal-org/aws//modules/organizational_unit"
  version = ">= 1.0.0"

  name           = "example"
  parent_id      = module.organization.root_organizational_unit
  allow_services = ["iam", "s3"]
}
```

[See more](./modules/organizational_unit/README.md).

### Creating an Account

This is the minimal config to create an Account.

```terraform
module "account" {
  source  = "george-richardson/personal-org/aws//modules/account"
  version = ">= 1.0.0"

  name  = "example"
  email = "example@example.org"
}
```

This config will create a billing alarm at 20USD per month, sent to the organization's billing alarm SNS topic.

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

[See more](./modules/account/README.md).

### Creating an SCP

There is also a helper module for creating Service Control Policies.

This config will create a SCP that blocks access by the root user and protects an IAM role named "myrole" from modification. 

```terraform
module "scp" {
  source  = "george-richardson/personal-org/aws//modules/scp"
  version = ">= 1.0.0"

  block_root_user         = true
  protected_iam_resources = ["arn:aws:iam::*:role/myrole"]
}
```

[See more](./modules/scp/README.md).

## Bootstrapping

Before using these modules it is recommended that you have the following in place:

1. An AWS account to use as your Organization root account.  
   Ideally, this would be a completely fresh account. This account must also have [billing metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html#turning_on_billing_metrics) enabled for billing alarms to work.
1. An S3 bucket to store your Terraform state in within the above account.
1. An IAM user with limited priviliges to use to access your AWS estate. 

2 and 3 can be provided with the [bootstrap](./bootstrap/) CloudFormation template and provisioning script. The bootstrap template will also create a role intended to be used for least privilege deployment of these modules (by default it is named 'organization-admin').

There is a [bootstrap.sh](./bootstrap/bootstrap.sh) helper script which can help you deploy the bootstrap CloudFormation template and then configure your new user's credentials and MFA.

## Tips and Tricks

### Role management

I recommend using [`aws-vault`](https://github.com/99designs/aws-vault) to assume roles in your child accounts. The `aws-vault login` command is also really helpful for switching between roles in the AWS Console.

### Account email addresses

Many email services (e.g. [gmail](https://support.google.com/a/users/answer/9308648?hl=en)) allow you to use email aliases. This feature makes it easier to set up multiple AWS accounts with one inbox. 

For example the addresses `joe.bloggs+aws.account.1@gmail.com` and `joe.bloggs+aws.account.2@gmail.com` can be used separately as root account email addresses, but both will send emails to the `joe.bloggs@gmail.com` inbox.

If you are not able to use email aliases then the Acccount module's `budget_notification_emails` variable can be used to centralize the budget notifications. 

## License

These modules are made available under an [MIT license](./LICENSE.md). 

Although the MIT license allows for commercial use, I would highly recommend against utilising these modules in a business context.

## Issues and Contributing

Due to the bureaucratic and time consuming nature of provisioning and deleting organizations and 
accounts I am unlikely to investigate issues that don't personally affect me. Code contributions for bug fixes are always welcome!

If you wish to add a new feature please [contact me](https://gjhr.me/contact.html) before starting work to check if I will be willing to merge. Feel free to fork!
