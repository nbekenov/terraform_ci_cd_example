
variable "region" {
  description = "AWS region where the resources will be deployed"
  default     = ""
}

variable "profile" {
  description = "AWS profile"
  default     = ""
}

variable "project_name" {
  description = "Project name"
  default     = ""
}

variable "account_id" {
  description = "Account ID where resources will be deployed"
  type        = string
  default     = ""
}

variable "prod_account_id" {
  description = "Account ID where resources will be deployed"
  type        = string
  default     = ""
}

variable "test_account_id" {
  description = "Account ID where resources will be deployed"
  type        = string
  default     = ""
}

variable "default_tags" {
  description = "Resources tags"
  type = object({
    Environment    = string
    TargetAccounts = string
    DeploymentType = string
  })
  default = {
    Environment    = "Deployment"
    TargetAccounts = "Demo"
    DeploymentType = "Terraform"
  }
}