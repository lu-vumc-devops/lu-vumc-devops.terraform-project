terraform {
  backend "s3" {
    bucket  = "952122846739-infrastructure"
    key     = "services/dev/vpc/terraform.tfstate"
    region  = "us-west-2"
    profile = "lu-vumc-devops"
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "lu-vumc-devops"
}

locals {
  tags = {
    Namespace = "lu-vumc-devops"
    Stage     = "dev"
  }
}

module "vpc" {
  source = "../../../modules/vpc"

  tags = local.tags
}
