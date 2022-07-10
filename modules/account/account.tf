resource "aws_organizations_account" "account" {
  name                       = var.name
  email                      = var.email
  parent_id                  = var.parent_id
  iam_user_access_to_billing = "ALLOW"
  close_on_deletion          = var.close_on_deletion
}
