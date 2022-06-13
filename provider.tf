terraform {
  required_providers {
    aws = {
      version = "~> 4.2.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = var.default_tags
  }
}
