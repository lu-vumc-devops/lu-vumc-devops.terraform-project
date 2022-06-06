terraform {
  backend "s3" {
    bucket  = "952122846739-infrastructure"
    key     = "services/dev/ansible/terraform.tfstate"
    region  = "us-west-2"
    profile = "lu-vumc-devops"
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "lu-vumc-devops"
}

locals {
  base_name = "ansible"
  owner     = "janis-sniegs"

  tags = {
    Namespace = "lu-vumc-devops"
    Stage     = "dev"
    Name      = local.base_name
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

module "ansible_master" {
  source = "../../../modules/ec2"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block = "0.0.0.0/0"
  subnet_id  = data.terraform_remote_state.vpc.outputs.public_subnet_id
  vpc_security_group_ids = [
    data.terraform_remote_state.vpc.outputs.sg_allow_ssh_id
  ]
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_iam_role_instance_profile.id
  ami                  = "ami-0ee8244746ec5d6d4" # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-04-20
  user_data            = <<EOF
#!/bin/bash
echo "sysops ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sysops
sudo apt update
sudo apt updgrade –y
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible
ansible –-version
EOF

  tags = {
    Name      = "4-grupa-${local.owner}-${local.base_name}-master"
    Owner     = local.owner
    Namespace = "lu-vumc-devops"
    Stage     = "dev"
  }
}

module "ansible_slave_1" {
  source = "../../../modules/ec2"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block = "0.0.0.0/0"
  subnet_id  = data.terraform_remote_state.vpc.outputs.public_subnet_id
  vpc_security_group_ids = [
    data.terraform_remote_state.vpc.outputs.sg_allow_http_https_id,
    data.terraform_remote_state.vpc.outputs.sg_allow_ssh_id
  ]
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_iam_role_instance_profile.id
  ami                  = "ami-0ee8244746ec5d6d4" # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-04-20

  tags = {
    Name      = "4-grupa-${local.owner}-${local.base_name}-slave-1"
    Owner     = local.owner
    Namespace = "lu-vumc-devops"
    Stage     = "dev"
  }
}

module "ansible_slave_2" {
  source = "../../../modules/ec2"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block = "0.0.0.0/0"
  subnet_id  = data.terraform_remote_state.vpc.outputs.public_subnet_id
  vpc_security_group_ids = [
    data.terraform_remote_state.vpc.outputs.sg_allow_http_https_id,
    data.terraform_remote_state.vpc.outputs.sg_allow_ssh_id
  ]
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_iam_role_instance_profile.id
  ami                  = "ami-0ee8244746ec5d6d4" # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-04-20

  tags = {
    Name      = "4-grupa-${local.owner}-${local.base_name}-slave-2"
    Owner     = local.owner
    Namespace = "lu-vumc-devops"
    Stage     = "dev"
  }
}

resource "aws_iam_role" "ec2_iam_role" {
  name = "${local.base_name}-ec2-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ec2_iam_role_policy_attachment" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_iam_role_instance_profile" {
  name = "${local.base_name}-ec2-instance-profile"
  role = aws_iam_role.ec2_iam_role.name
}
