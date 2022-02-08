resource aws_vpc "my_vpc" {
  cidr_block = var.vpc_cidr
  tags       = {
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

resource "aws_subnet" "my_public_subnet" {
  cidr_block              = var.public_subnet_cidr
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone       = var.subnet_az
  map_public_ip_on_launch = true
  tags                    = {
    Name = "my_public_subnet"
  }
}
// Subnet end


// Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = {
    Name = "My IGW"
  }
}

// Route table start
resource "aws_route_table" "my_vpc_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = {
    Name = "My VPC Route table"
  }
}

resource "aws_route_table_association" "my_private_subnet_association" {
  route_table_id = aws_vpc.my_vpc.default_route_table_id
  subnet_id      = aws_subnet.my_private_subnet.id
}

resource "aws_route_table_association" "my_public_subnet_association" {
  route_table_id = aws_route_table.my_vpc_route_table.id
  subnet_id      = aws_subnet.my_public_subnet.id
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.my_vpc_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
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
// VPC Endpoint end

// Security groups
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "My public subnet SG"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "My private subnet SG"
  ingress {
    security_groups = [aws_security_group.public_sg.id]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}
// Security Groups end