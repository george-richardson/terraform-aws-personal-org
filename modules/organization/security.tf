data "aws_region" "current" {}

data "aws_iam_user" "organization_owner" {
  user_name = var.organization_owner_user_name
}

# Stack set for organization-owner role in child accounts.

resource "aws_cloudformation_stack_set" "organization_owner_role" {
  name             = "organization-owner-role"
  permission_model = "SERVICE_MANAGED"
  template_body    = file("${path.module}/cloudformation/organization-owner-role.yml")
  capabilities     = ["CAPABILITY_NAMED_IAM"]

  parameters = {
    RoleName         = var.organization_owner_role_name != "" ? var.organization_owner_role_name : data.aws_iam_user.organization_owner.user_name
    PrivilegedEntity = data.aws_iam_user.organization_owner.arn
  }

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  lifecycle {
    ignore_changes = [administration_role_arn]
  }
}

resource "aws_cloudformation_stack_set_instance" "organization_owner_role" {
  region         = data.aws_region.current.name
  stack_set_name = aws_cloudformation_stack_set.organization_owner_role.name

  deployment_targets {
    organizational_unit_ids = [local.root_ou]
  }
}
