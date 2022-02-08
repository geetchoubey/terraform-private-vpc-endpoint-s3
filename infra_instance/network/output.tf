output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.my_public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.my_private_subnet.id
}

output "private_sg" {
  value = aws_security_group.private_sg.id
}

output "public_sg" {
  value = aws_security_group.public_sg.id
}