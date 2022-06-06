resource "aws_instance" "web" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile
  user_data                   = var.user_data

  tags = var.tags
}
