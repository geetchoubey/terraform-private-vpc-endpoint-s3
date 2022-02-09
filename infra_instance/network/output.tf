output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "private_subnet_id" {
  value = aws_subnet.my_private_subnet.id
}

output "private_sg" {
  value = aws_security_group.endpoint_sg.id
}