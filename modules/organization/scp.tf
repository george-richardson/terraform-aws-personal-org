module "scp" {
  source = "../scp"

  name                     = "root"
  attachments              = [local.root_ou]
  block_root_user          = var.block_root_user
  allow_regions            = var.allow_regions
  allow_services           = var.allow_services
  allow_ec2_instance_types = var.allow_ec2_instance_types
  allow_rds_instance_types = var.allow_rds_instance_types
  override_policy_documents = concat(
    var.override_policy_documents,
    var.deny_modifying_owner_role ? [data.aws_iam_policy_document.deny_organization_owner_role_delete.json] : []
  )
}

data "aws_iam_policy_document" "deny_organization_owner_role_delete" {
  statement {
    sid       = "DenyModifyingOrgOwnerRole"
    effect    = "Deny"
    actions   = ["iam:*"]
    resources = ["arn:aws:iam::*:role/${data.aws_iam_user.organization_owner.user_name}"]
  }
}