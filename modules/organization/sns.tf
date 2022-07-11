resource "aws_sns_topic" "billing_alarms" {
  name = var.billing_alarms_topic_name

  lifecycle {
    precondition {
      condition     = data.aws_region.current.name == "us-east-1"
      error_message = "Billing data for alarms is only available in the us-east-1 region."
    }
  }
}

data "aws_region" "current" {}

resource "aws_sns_topic_subscription" "billing_alarms_emails" {
  for_each  = toset(var.billing_alarms_email_subscribers)
  topic_arn = aws_sns_topic.billing_alarms.arn
  protocol  = "email"
  endpoint  = each.value
}
