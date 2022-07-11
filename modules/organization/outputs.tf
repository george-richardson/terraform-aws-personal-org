output "root_organizational_unit" {
  value       = local.root_ou
  description = "ID of the root organizational unit of the organization."
}

output "billing_alarms_topic" {
  value       = aws_sns_topic.billing_alarms.arn
  description = "ARN of the billing alarms SNS topic."
}
