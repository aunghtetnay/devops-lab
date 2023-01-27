resource "aws_vpc" "terraform-lab-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-lab-vpc"
  }
}

# Public subnetss
resource "aws_subnet" "public-subnet-1" { 
  tags = {
    Name = "public-terraform-lab-subnet-1"
  }
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.terraform-lab-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "public-subnet-2" { 
  tags = {
    Name = "public-terraform-lab-subnet-2"
  }
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.terraform-lab-vpc.id
  availability_zone = var.availability_zones[1]
}

# Private subnets
resource "aws_subnet" "private-subnet-1" {
  tags = {
    Name = "private-terraform-lab-subnet-1"
  }
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.terraform-lab-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "private-subnet-2" {
  tags = {
    Name = "private-terraform-lab-subnet-2"
  }
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.terraform-lab-vpc.id
  availability_zone = var.availability_zones[1]
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "terraform-lab-igw" {
  tags = {
    Name = "terraform-lab-igw"
  }
  vpc_id = aws_vpc.terraform-lab-vpc.id
}

# NAT Gateway for the public subnet
resource "aws_eip" "nat_gateway" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"
  depends_on                = [aws_internet_gateway.terraform-lab-igw]
}
resource "aws_nat_gateway" "terraform-lab-ngw" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "terraform-lab-ngw"
  }
  depends_on = [aws_eip.nat_gateway]
}

# Route tables for the subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.terraform-lab-vpc.id
  tags = {
    Name = "public-terraform-lab-route-table"
  }
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.terraform-lab-vpc.id
  tags = {
    Name = "private-terraform-lab-route-table"
  }
}

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.terraform-lab-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Route NAT Gateway
resource "aws_route" "nat-ngw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.terraform-lab-ngw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Associate the newly created route tables to the subnets
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}