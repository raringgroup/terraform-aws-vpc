## ----------------------------------------------------------------------------
## Copyright 2026 Raring Group LLC
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
## ----------------------------------------------------------------------------

provider "aws" {
  region = var.region
}


module "vpc" {
  source                  = "../../"
  ipv4_primary_cidr_block = "172.16.0.0/16"
  ipv4_additional_cidr_block_associations = {
    "172.22.0.0/16" = {
      ipv4_cidr_block     = "172.22.0.0/16"
      ipv4_ipam_pool_id   = null
      ipv4_netmask_length = null
    }
  }
  ipv4_cidr_block_association_timeouts = {
    create = "3m"
    delete = "5m"
  }

  assign_generated_ipv6_cidr_block = true

  default_security_group_deny_all = var.default_security_group_deny_all
  default_route_table_no_routes   = var.default_route_table_no_routes
  default_network_acl_deny_all    = var.default_network_acl_deny_all

  context = module.context.self
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.0.4"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.context.self
}

# Verify that a disabled VPC generates a plan without errors
module "vpc_disabled" {
  source  = "../../"
  enabled = false

  ipv4_primary_cidr_block          = "172.16.0.0/16"
  assign_generated_ipv6_cidr_block = true

  context = module.context.self
}
