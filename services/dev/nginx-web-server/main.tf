terraform {
  backend "s3" {
    bucket  = "952122846739-infrastructure"
    key     = "services/dev/nginx-web-server/terraform.tfstate"
    region  = "us-west-2"
    profile = "lu-vumc-devops"
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

locals {
  tags = {
    namespace = "lu-vumc-devops"
    stage     = "dev"
    name      = "ec2-server"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  tags = local.tags
}

module "ec2" {
  source = "../../modules/ec2"

  tags = local.tags
}
