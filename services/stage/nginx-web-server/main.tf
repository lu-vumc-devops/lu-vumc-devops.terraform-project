terraform {
  backend "s3" {
    bucket  = "952122846739-infrastructure"
    key     = "services/stage/nginx-web-server/terraform.tfstate"
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
    Stage     = "stage"
    Name      = "nginx-web-server"
  }
}

module "vpc" {
  source = "../../../modules/vpc"

  tags = local.tags
}

module "ec2" {
  source = "../../../modules/ec2"

  vpc_id        = module.vpc.vpc_id
  cidr_block    = "0.0.0.0/0"
  subnet_id     = module.vpc.public_subnet_id
  instance_type = "t3.medium"
  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
EOF

  tags = local.tags
}
