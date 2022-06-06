terraform {
  backend "s3" {
    bucket  = "952122846739-infrastructure"
    key     = "services/prod/acme-landing-page/terraform.tfstate"
    region  = "us-west-2"
    profile = "lu-vumc-devops"
  }
}
