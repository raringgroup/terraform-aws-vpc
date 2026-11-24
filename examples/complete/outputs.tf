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

output "public_subnet_cidrs" {
  value = module.subnets.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = module.subnets.private_subnet_cidrs
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

output "additional_cidr_blocks" {
  description = "A list of the additional IPv4 CIDR blocks associated with the VPC"
  value       = module.vpc.additional_cidr_blocks
}

output "additional_cidr_blocks_to_association_ids" {
  description = "A map of the additional IPv4 CIDR blocks to VPC CIDR association IDs"
  value       = module.vpc.additional_cidr_blocks_to_association_ids
}

output "vpc_ipv6_association_id" {
  value       = module.vpc.vpc_ipv6_association_id
  description = "The association ID for the primary IPv6 CIDR block"
}

output "vpc_ipv6_cidr_block" {
  value       = module.vpc.vpc_ipv6_cidr_block
  description = "The primary IPv6 CIDR block"
}

output "ipv6_cidr_block_network_border_group" {
  value       = module.vpc.ipv6_cidr_block_network_border_group
  description = "The Network Border Group Zone name"
}
