# Org Root

resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.aws_service_access_principals
  feature_set                   = "ALL"
  enabled_policy_types          = var.enabled_policy_types
}

locals {
  root_ou = aws_organizations_organization.org.roots[0].id
}