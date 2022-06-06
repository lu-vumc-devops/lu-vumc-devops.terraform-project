terraform {
  backend "s3" {
    bucket  = "952122846739-infrastructure"
    key     = "init/terraform.tfstate"
    region  = "us-west-2"
    profile = "lu-vumc-devops"
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

module "init" {
  source = "git@github.com:lu-vumc-devops/lu-vumc-devops.terraform-modules//modules/aws-account-init?ref=main"

  namespace     = "lu-vumc-devops"
  name          = "terraform"
  stage         = "prod"
  attributes    = ["init"]
  delimiter     = "-"
  account_alias = "lu-vumc-devops"
  region        = var.region
  profile       = var.profile
}
