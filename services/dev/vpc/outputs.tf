output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "nat_gateway_eip_address" {
  value = module.vpc.nat_gateway_eip_address
}

output "sg_allow_http_https_id" {
  value = module.vpc.sg_allow_http_https_id
}

output "sg_allow_ssh_id" {
  value = module.vpc.sg_allow_ssh_id
}
