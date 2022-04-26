variable "tags" {
    type = map
    default = {
        Name = "HelloWorld"
        Environment = "Development"
        Product = "Website"
    }
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}
