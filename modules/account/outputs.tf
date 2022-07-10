output "id" {
  value       = aws_organizations_account.account.id
  description = "ID of the account."
}

output "role_arn" {
  value = "arn:aws:iam::${aws_organizations_account.account.id}:role/OrganizationAccountAccessRole"
  description = "ARN of the OrganizationAccountAccessRole for this account."
}
