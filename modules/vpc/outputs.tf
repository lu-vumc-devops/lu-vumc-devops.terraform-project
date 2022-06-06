output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.public.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "nat_gateway_eip_address" {
  value = aws_eip.nat_eip.address
}

output "sg_allow_http_https_id" {
  value = aws_security_group.allow_http_https.id
}

output "sg_allow_ssh_id" {
  value = aws_security_group.allow_ssh.id
}
