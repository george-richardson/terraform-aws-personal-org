# Account

variable "name" {
  type        = string
  description = "Alias for the account."
}

variable "email" {
  type        = string
  description = "Email address to use for the new account."
}

variable "close_on_deletion" {
  type        = bool
  description = "Whether to close the account when deleted from the organization."
  default     = true
}

variable "iam_user_access_to_billing" {
  type        = string
  description = "Allow IAM resources access to billing. Valid values are 'ALLOW' or 'DENY', by default a null value will match to 'ALLOW'."
  default     = null
  validation {
    condition     = can(regex("^(ALLOW|DENY)$", var.iam_user_access_to_billing)) || var.iam_user_access_to_billing == null
    error_message = "IAM user access to billing must match either 'ALLOW', 'DENY' or null."
  }
}

# Budget

variable "billing_alarm_threshold" {
  type        = number
  description = "Threshold for monthly spending in USD to alert at. Omit or use value -1 to disable."
  default     = -1
}

variable "billing_alarm_sns_topic" {
  type        = string
  description = "SNS topic to notify if this account breaches its spending threshold. If not set, then alarm will still be created but no action will be taken."
  default     = ""
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
