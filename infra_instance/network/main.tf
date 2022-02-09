resource aws_vpc "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = {
    Name = "my_vpc"
  }
}

// Subnet start
resource "aws_subnet" "my_private_subnet" {
  cidr_block        = var.private_subnet_cidr
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = var.subnet_az
  tags              = {
    Name = "my_private_subnet"
  }
}
// Subnet end

// Route table start}
resource "aws_route_table_association" "my_private_subnet_association" {
  route_table_id = aws_vpc.my_vpc.default_route_table_id
  subnet_id      = aws_subnet.my_private_subnet.id
}
// Route table end

// VPC Endpoint start
resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_id       = aws_vpc.my_vpc.id
}

resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_association" {
  route_table_id  = aws_vpc.my_vpc.default_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3_vpc_endpoint.id
}

resource "aws_vpc_endpoint" "endpoints" {
  count               = length(var.vpc_endpoints)
  vpc_id              = aws_vpc.my_vpc.id
  service_name        = "com.amazonaws.${var.region}.${var.vpc_endpoints[count.index]}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = "true"
  security_group_ids  = [
    aws_security_group.endpoint_sg.id
  ]
  subnet_ids          = [aws_subnet.my_private_subnet.id]
}
// VPC Endpoint end

// Security groups
resource "aws_security_group" "endpoint_sg" {
  name        = "demo-endpoint-sg"
  description = "Security Group for VPC Endpoints"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
// Security Groups end