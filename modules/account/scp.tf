module "scp" {
  source = "../scp"

  name                     = var.name
  attachments              = [aws_organizations_account.account.id]
  block_root_user          = var.block_root_user
  allow_regions            = var.allow_regions
  allow_services           = var.allow_services
  allow_ec2_instance_types = var.allow_ec2_instance_types
  allow_rds_instance_types = var.allow_rds_instance_types
}