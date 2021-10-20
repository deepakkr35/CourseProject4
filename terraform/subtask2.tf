# creating AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "assignment-vpc"
  }
}

# creating internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "assignment-igw"
  }
}

# creating NAT gateway
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet-1.id
  depends_on    = [aws_internet_gateway.gw]
}

# creating first Public subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "assigment-public-subnet-1"
  }
}

# creating second Public subnet
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "assigment-public-subnet-2"
  }
}

# Creating first Private Subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "10.0.2.0/24"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "assigment-private-subnet-1"
  }
}

# Creating second Private Subnet
resource "aws_subnet" "private-subnet-2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "10.0.4.0/24"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "assigment-private-subnet-2"
  }
}

# creating aws route table
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags       = {
    Name     = "assignment-public-route-table"
  }
}

# Associating Public Subnet 1 to Public Route Table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-1.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associating Public Subnet 2 to Public Route Table
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-2.id
  route_table_id      = aws_route_table.public-route-table.id
}

# creating route table for private
# Add routes for VPC
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "private"
  }
}

# Creating route associations for private Subnets
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private.id
}

# Creating route associations for private Subnets
resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private.id
}

# VPC ID
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

# VPC Public Subnets
output "public_subnets_1" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public-subnet-1
}
output "public_subnets_2" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public-subnet-2
}

# VPC Private Subnets
output "private_subnets_1" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.public-subnet-1
}
output "private_subnets_2" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.public-subnet-2
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_nat_gateway.nat-gw.public_ip
}


# AWS EC2 Security Group Terraform Outputs

output "Bastion_service_sg_group_id" {
  description = "The ID of the Bastion service security group"
  value       = aws_security_group.bastion.id
}

# bastion_sg_group_name
output "Bastion_service_sg_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.bastion.name
  
}

# private_sg_group_id
output "Private_Instance_sg_group_id" {
  description = "The ID of the private security group"
  value       = aws_security_group.private.id
}

# private_sg_group_name
output "Private_Instance_sg_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.private.name
}


## EC2 details for bastion 
output "ec2_instance_Bastion_id" {
  description = "List of IDs of instances"
  value       = aws_instance.bastion.id
}

# EC2 details for Jenkins
output "ec2_instance_Jenkins_ids" {
  description = "List of IDs of instances"
  value       = aws_instance.jenkins-instance.id
}

# EC2 details for App
output "ec2_instance_private_App_ids" {
  description = "List of IDs of instances"
  value       = aws_instance.app.id
}

