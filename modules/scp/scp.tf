locals {
  create_policy = (
    var.block_root_user
    || length(var.allow_regions) != 0
    || length(var.allow_services) != 0
    || length(var.allow_ec2_instance_types) != 0
    || length(var.allow_rds_instance_types) != 0
    || length(var.override_policy_documents) != 0
  )
}

resource "aws_organizations_policy" "scp" {
  # Only create if any denies would actually be created
  for_each = toset(local.create_policy ? ["true"] : [])
  name     = var.name
  content  = data.aws_iam_policy_document.scp.json
}

resource "aws_organizations_policy_attachment" "attachment" {
  for_each  = local.create_policy ? toset(var.attachments) : []
  policy_id = aws_organizations_policy.scp["true"].id
  target_id = each.value
}

data "aws_iam_policy_document" "scp" {
  override_policy_documents = var.override_policy_documents
  # Block root user
  dynamic "statement" {
    # Only include this statement if block_root_user is set to true
    for_each = var.block_root_user ? ["true"] : []
    content {
      sid       = "DenyRootUser"
      effect    = "Deny"
      actions   = ["*"]
      resources = ["*"]
      condition {
        test     = "StringLike"
        variable = "aws:PrincipalArn"
        values   = ["arn:aws:iam::*:root"]
      }
    }
  }

  # Region restrictions
  dynamic "statement" {
    # Only include this statement if allow_regions is set
    for_each = length(var.allow_regions) == 0 ? [] : ["true"]
    content {
      sid    = "DenyRegions"
      effect = "Deny"

      # See https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html#example-scp-deny-region
      # Allows global services through
      not_actions = [
        "a4b:*",
        "acm:*",
        "aws-marketplace-management:*",
        "aws-marketplace:*",
        "aws-portal:*",
        "budgets:*",
        "ce:*",
        "chime:*",
        "cloudfront:*",
        "config:*",
        "cur:*",
        "directconnect:*",
        "ec2:DescribeRegions",
        "ec2:DescribeTransitGateways",
        "ec2:DescribeVpnGateways",
        "fms:*",
        "globalaccelerator:*",
        "health:*",
        "iam:*",
        "importexport:*",
        "kms:*",
        "mobileanalytics:*",
        "networkmanager:*",
        "organizations:*",
        "pricing:*",
        "route53:*",
        "route53domains:*",
        "s3:GetAccountPublic*",
        "s3:ListAllMyBuckets",
        "s3:PutAccountPublic*",
        "shield:*",
        "sts:*",
        "support:*",
        "trustedadvisor:*",
        "waf-regional:*",
        "waf:*",
        "wafv2:*",
        "wellarchitected:*"
      ]

      resources = ["*"]

      condition {
        test     = "StringNotEquals"
        variable = "aws:RequestedRegion"
        values   = var.allow_regions
      }
    }
  }

  # Service restrictions
  dynamic "statement" {
    # Only include this statement if allow_services is set
    for_each = length(var.allow_services) == 0 ? [] : ["true"]
    content {
      sid    = "DenyServices"
      effect = "Deny"

      not_actions = [
        for service in var.allow_services :
        "${service}:*"
      ]

      resources = ["*"]
    }
  }

  # Instance type restrictions
  dynamic "statement" {
    # Only include this statement if allow_ec2_instance_types is set
    for_each = length(var.allow_ec2_instance_types) == 0 ? [] : ["true"]
    content {
      sid    = "DenyEC2InstanceTypes"
      effect = "Deny"

      actions = ["ec2:RunInstances"]

      resources = ["arn:aws:ec2:*:*:instance/*"]

      condition {
        test     = "StringNotEquals"
        variable = "ec2:InstanceType"
        values   = var.allow_ec2_instance_types
      }
    }
  }

  dynamic "statement" {
    # Only include this statement if allow_rds_instance_types is set
    for_each = length(var.allow_rds_instance_types) == 0 ? [] : ["true"]
    content {
      sid    = "DenyRDSInstanceTypes"
      effect = "Deny"

      actions = [
        "rds:CreateDBCluster",
        "rds:RestoreDBClusterFromSnapshot"
      ]

      resources = ["arn:*:rds:*:*:db:*"]

      condition {
        test     = "StringNotEquals"
        variable = "rds:DatabaseClass"
        values   = var.allow_rds_instance_types
      }
    }
  }
}
