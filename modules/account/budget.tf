resource "aws_budgets_budget" "account" {
  # Only create a budget if there is a non zero budget value.
  for_each     = var.budget != 0 ? [true] : []
  account_id   = aws_organizations_account.account.id
  name         = var.name
  budget_type  = "COST"
  limit_amount = var.budget
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = var.budget_notification_type
    subscriber_email_addresses = concat([var.email], var.budget_notification_emails)
  }
}
