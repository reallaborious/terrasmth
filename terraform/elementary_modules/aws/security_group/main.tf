terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "this" {
  name   = var.name
  vpc_id = var.vpc_id
  tags   = var.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each          = { for idx, rule in var.ingress_rules : idx => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.this.id
  cidr_blocks       = each.value.cidr_blocks
}
