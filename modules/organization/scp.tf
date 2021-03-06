module "scp" {
  source = "../scp"

  name                      = "root"
  attachments               = [local.root_ou]
  block_root_user           = var.block_root_user
  allow_regions             = var.allow_regions
  allow_services            = var.allow_services
  allow_ec2_instance_types  = var.allow_ec2_instance_types
  allow_rds_instance_types  = var.allow_rds_instance_types
  protected_iam_resources   = concat(var.protected_iam_resources, var.block_organization_role_modification ? ["arn:aws:iam::*:role/OrganizationAccountAccessRole"] : [])
  override_policy_documents = var.override_policy_documents
}
