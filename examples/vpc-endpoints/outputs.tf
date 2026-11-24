## ----------------------------------------------------------------------------
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
## ----------------------------------------------------------------------------

output "public_subnet_cidrs" {
  value       = module.subnets.public_subnet_cidrs
  description = "The CIDR block ranges of the public subnets belonging to the VPC."
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "The CIDR block ranges of the private subnets belonging to the VPC."
}

output "vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "The CIDR block range of the VPC."
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC."
}

output "gateway_vpc_endpoints" {
  value       = module.vpc_endpoints.gateway_vpc_endpoints_map
  description = "List of Gateway VPC Endpoints deployed to the VPC."
}

output "interface_vpc_endpoints" {
  value       = module.vpc_endpoints.interface_vpc_endpoints_map
  description = "List of Interface VPC Endpoints deployed to the VPC."
}
