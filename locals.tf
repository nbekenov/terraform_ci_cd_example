locals {
  region     = var.region != "" ? var.region : data.aws_region.current.name
  account_id = var.account_id != "" ? var.account_id : data.aws_caller_identity.current.account_id

  resource_prefix = "${var.project_name}-${local.region}"
}