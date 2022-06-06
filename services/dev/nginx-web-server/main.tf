terraform {
  backend "s3" {
    bucket  = "952122846739-infrastructure"
    key     = "services/dev/nginx-web-server/terraform.tfstate"
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
    Name      = "nginx-web-server"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "952122846739-infrastructure"
    region  = "us-west-2"
    profile = "lu-vumc-devops"
    key     = "services/dev/vpc/terraform.tfstate"
  }
}

module "ec2" {
  source = "../../../modules/ec2"

  vpc_id        = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block    = "0.0.0.0/0"
  subnet_id     = data.terraform_remote_state.vpc.outputs.public_subnet_id
  instance_type = "t3.micro"
  ami           = "ami-0ca285d4c2cda3300" # Amazon Linux 2 Kernel 5.10 AMI 2.0.20220426.0 x86_64 HVM gp2
  user_data     = <<EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
EOF

  tags = local.tags
}
