# Account

variable "name" {
  type        = string
  description = "Alias for the account."
}

variable "email" {
  type        = string
  description = "Email address to use for the new account."
}

# Budget

variable "budget" {
  type        = number
  description = "Threshold for monthly spending in USD to alert at."
}

variable "budget_notification_emails" {
  type        = list(string)
  description = "Additional email addresses to send budget notifications to. The email variable will be included by default."
  default     = []
}

variable "budget_notification_type" {
  type        = string
  description = "Notify on either 'FORECASTED' or 'ACTUAL' spending."
  default     = "FORECASTED"
  validation {
    condition     = can(regex("^(FORECASTED|ACTUAL-.*)$", var.budget_notification_type))
    error_message = "Budget notification type must match either 'ACTUAL' or 'FORECASTED'."
  }
}

# Org

variable "parent_id" {
  type        = string
  description = "ID of the organizational unit this account should be a part of."
  default     = null
}

# SCP

variable "block_root_user" {
  type        = bool
  description = "Should the root user have all access blocked?"
  default     = false
}

variable "allow_regions" {
  type        = list(string)
  description = "List of regions to allow AWS activity within. (Global services are ignored by this list)"
  default     = []
}

variable "allow_services" {
  type        = list(string)
  description = "List of services to allow API activity against. All other services will be blocked. Be careful about blocking IAM and other foundational services. When not set all services are allowed."
  default     = []
}

variable "allow_ec2_instance_types" {
  type        = list(string)
  description = "List of EC2 instance types to allow. If not set then all instance types are allowed."
  default     = []
}

variable "allow_rds_instance_types" {
  type        = list(string)
  description = "List of RDS instance types to allow. If not set then all instance types are allowed."
  default     = []
}

variable "override_policy_documents" {
  type        = list(string)
  description = "List of JSON SCP policy documents that will be merged with the generated SCP."
  default     = []
}

variable "protected_iam_resources" {
  type        = list(string)
  description = "List of IAM ARNs which will be protected from modification by all users."
  default     = []
}
