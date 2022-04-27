terraform {
  backend "s3" {
    bucket  = "952122846739-infrastructure"
    key     = "init/terraform.tfstate"
    region  = "us-west-2"
    profile = "lu-vumc-devops"
  }





     
  required_version = ">= 1.1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.73.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = var.tags
}
