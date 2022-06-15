
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

variable "codebuild_image" {
  description = "CodeBuild image"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}


variable "codebuild_node_size" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"
}


variable "cb_priviledged_mode" {
  description = "Enable codebuild to use docker to build images"
  type        = string
  default     = "true"
}

variable "repo_branch_name" {
  description = "bitbucket repository branch name"
  type        = string
  default     = "master"
}

variable "bitbucket_repo_full_name" {
  description = "bitbucket repository full name"
  type        = string
  default     = ""
}