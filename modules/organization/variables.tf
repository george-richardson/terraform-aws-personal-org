# Org

variable "aws_service_access_principals" {
  type        = list(string)
  description = "List of AWS service principal names for which you want to enable integration with your organization."
  default = [
    "cloudtrail.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com"
  ]
}

variable "enabled_policy_types" {
  type        = list(string)
  description = "List of Organizations policy types to enable in the Organization Root."
  default = [
    "SERVICE_CONTROL_POLICY"
  ]
}

variable "bootstrap_stack_name" {
  type        = string
  description = "Name of the Cloudformation bootstrap stack which deploys the organization owner user."
}

# SCP

variable "deny_modifying_owner_role" {
  type        = bool
  description = "Should the organization owner role be protected from modification/deletion?"
  default     = true
}

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
