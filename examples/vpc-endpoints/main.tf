## ----------------------------------------------------------------------------
## Copyright 2026 Raring Group LLC
## Copyright 2017-2020 Cloud Posse, LLC
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## Derived from cloudposse/terraform-aws-vpc; modified by Raring Group LLC.
## ----------------------------------------------------------------------------

provider "aws" {
  region = var.region
}

locals {
  enabled    = module.context.enabled
  interfaces = ["ec2", "kinesis"]

  gateway_vpc_endpoints = {
    "s3" = {
      name = "s3"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "s3:*",
            ]
            Effect    = "Allow"
            Principal = "*"
            Resource  = "*"
          },
        ]
      })
      route_table_ids = [aws_route_table.other.id, module.vpc.vpc_default_route_table_id]
    }
    "dynamodb" = {
      name            = "dynamodb"
      policy          = null
      route_table_ids = [aws_route_table.other.id]
    }
  }
  interface_vpc_endpoints = {
    "ec2" = {
      name                = "ec2"
      security_group_ids  = [module.vpc.vpc_default_security_group_id, module.endpoint_security_groups[local.interfaces[0]].id]
      subnet_ids          = module.subnets.private_subnet_ids
      policy              = null
      private_dns_enabled = true
    }
    "kinesis-streams" = {
      name                = "kinesis-streams"
      security_group_ids  = [module.endpoint_security_groups[local.interfaces[1]].id, module.vpc.vpc_default_security_group_id]
      subnet_ids          = module.subnets.private_subnet_ids
      policy              = null
      private_dns_enabled = false
    }
  }
}

module "vpc" {
  source                   = "../../"
  ipv4_primary_cidr_block  = "172.17.0.0/16"
  internet_gateway_enabled = false

  context = module.context.self
}

resource "aws_route_table" "other" {
  vpc_id = module.vpc.vpc_id
}

module "vpc_endpoints" {
  source = "../../modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  gateway_vpc_endpoints   = local.gateway_vpc_endpoints
  interface_vpc_endpoints = local.interface_vpc_endpoints

  context = module.context.self
}


module "subnets" {
  source = "git::https://github.com/raringgroup/terraform-aws-dynamic-subnets.git?ref=v0.1.0"

  availability_zones     = var.availability_zones
  vpc_id                 = module.vpc.vpc_id
  igw_id                 = []
  ipv4_cidr_block        = [module.vpc.vpc_cidr_block]
  public_subnets_enabled = false
  nat_gateway_enabled    = false
  nat_instance_enabled   = false

  context = module.context.self
}

module "endpoint_security_groups" {
  for_each = local.enabled ? toset(local.interfaces) : []
  source   = "git::https://github.com/raringgroup/terraform-aws-security-group.git?ref=v0.1.0"

  create_before_destroy      = true
  preserve_security_group_id = false
  attributes                 = [each.value]
  vpc_id                     = module.vpc.vpc_id

  rules = [{
    key              = "vpc_ingress"
    type             = "ingress"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = compact(concat([module.vpc.vpc_cidr_block], module.vpc.additional_cidr_blocks))
    ipv6_cidr_blocks = compact(concat([module.vpc.vpc_ipv6_cidr_block], module.vpc.additional_ipv6_cidr_blocks))
    description      = "Ingress from VPC to ${each.value}"
  }]

  allow_all_egress = true

  context = module.context.self
}
