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

module "vpc" {
  source                  = "../../"
  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.context.self
}

module "subnets" {
  source = "git::https://github.com/raringgroup/terraform-aws-dynamic-subnets.git?ref=v0.1.0"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.context.self
}

# Verify that a disabled VPC generates a plan without errors
module "vpc_disabled" {
  source  = "../../"
  enabled = false

  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.context.self
}
