resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  for_each = toset(var.billing_alarm_threshold != -1 ? ["true"] : [])
  # Meta
  alarm_name        = "account-budget-${var.name}"
  alarm_description = "Monthly billing spend for the account ${var.name}"

  # Metric
  namespace   = "AWS/Billing"
  metric_name = "EstimatedCharges"
  dimensions = {
    "Currency"      = "USD"
    "LinkedAccount" = aws_organizations_account.account.id
  }

  # Alarm definiton
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.billing_alarm_threshold
  period              = "3600"
  evaluation_periods  = "1"
  treat_missing_data  = "notBreaching"

  # Actions
  alarm_actions = var.billing_alarm_sns_topic != "" ? [var.billing_alarm_sns_topic] : []

  lifecycle {
    precondition {
      condition     = data.aws_region.current.name == "us-east-1"
      error_message = "Billing alarms must be created in us-east-1 or the data will not be available."
    }
  }
}

data "aws_region" "current" {}
