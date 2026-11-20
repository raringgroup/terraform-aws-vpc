# -----------------------------------------------------------------------------
# Copyright 2026 Raring Group LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# -----------------------------------------------------------------------------

# TERRAGRUNT - VPC EXAMPLE
# ------------------------------------------------------------------------------
# examples/complete/terragrunt.hcl
#
# Deploys the complete example to AWS. Generates the S3 backend and
# passes the standard context inputs.
#
# Required environment variables:
#   AWS_REGION            the region to deploy to
#   TF_STATE_BUCKET       S3 bucket that holds the Terraform state
#   TF_STATE_LOCK_TABLE   DynamoDB table used for state locking
#   TF_STATE_REGION       region of the state bucket
#
# Module: this repository
# ------------------------------------------------------------------------------

locals {
  account_id = get_aws_account_id()
  region     = get_env("AWS_REGION")

  namespace   = "rg"
  tenant      = "Raring"
  project     = "vpc"
  environment = ""
  stage       = basename(get_terragrunt_dir())

  tags                = { Source = "Managed by Terraform" }
  regex_replace_chars = "/[^-a-zA-Z0-9]/"
  delimiter           = "-"
  id_length_limit     = 0
  label_key_case      = "title"
  label_value_case    = "lower"
  label_order         = ["namespace", "project", "environment", "stage", "name", "attributes"]
}


remote_state {
  backend = "s3"

  config = {
    bucket                = get_env("TF_STATE_BUCKET")
    disable_bucket_update = true
    dynamodb_table        = get_env("TF_STATE_LOCK_TABLE")
    encrypt               = true
    key                   = "${local.account_id}/${local.project}/${local.stage}/terraform.tfstate"
    region                = get_env("TF_STATE_REGION")
  }

  generate = {
    path      = "generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


inputs = {
  # Standard Context
  delimiter           = local.delimiter
  environment         = local.environment
  id_length_limit     = local.id_length_limit
  label_key_case      = local.label_key_case
  label_order         = local.label_order
  label_value_case    = local.label_value_case
  namespace           = local.namespace
  project             = local.project
  regex_replace_chars = local.regex_replace_chars
  region              = local.region
  stage               = local.stage
  tags                = local.tags
  tenant              = local.tenant

  # Example Specific
  # Adjust if your account does not have these availability zones.
  availability_zones              = ["${local.region}a", "${local.region}b"]
  default_network_acl_deny_all    = true
  default_route_table_no_routes   = true
  default_security_group_deny_all = true
}
