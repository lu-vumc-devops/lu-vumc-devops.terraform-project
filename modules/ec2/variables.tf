variable "tags" {}
variable "vpc_id" {}
variable "cidr_block" {}
variable "subnet_id" {}
variable "instance_type" {}
variable "iam_instance_profile" {}
variable "vpc_security_group_ids" {}
variable "ami" {}
variable "user_data" {
    default = ""
}
