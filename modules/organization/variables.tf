# Org

variable "aws_service_access_principals" {
  type        = list(string)
  description = "List of AWS service principal names for which you want to enable integration with your organization."
  default     = []
}

variable "enabled_policy_types" {
  type        = list(string)
  description = "List of Organizations policy types to enable in the Organization Root."
  default = [
    "SERVICE_CONTROL_POLICY"
  ]
}

# SCP

variable "block_organization_role_modification" {
  type        = bool
  description = "Should modification of OrganizationAccountAccessRole in child accounts be blocked?"
  default     = true
}

variable "block_root_user" {
  type        = bool
  description = "Should the root user have all access blocked?"
  default     = true
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
