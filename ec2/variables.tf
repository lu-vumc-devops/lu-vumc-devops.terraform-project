variable "region" {
  default = "us-west-2"
}

variable "profile" {
  default = "lu-vumc-devops"
}

variable "tags" {
  type = map(any)
  default = {
    Name        = "HelloWorld"
    Environment = "Development"
    Product     = "Website"
  }
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
