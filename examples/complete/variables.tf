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

variable "availability_zones" {
  type = list(string)
}

variable "default_security_group_deny_all" {
  type = bool
}

variable "default_route_table_no_routes" {
  type = bool
}

variable "default_network_acl_deny_all" {
  type = bool
}
