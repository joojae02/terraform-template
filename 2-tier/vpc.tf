# vpc 생성
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr
}

# public subnet 1
resource "aws_subnet" "public_subnet1" {   
   vpc_id            = aws_vpc.custom_vpc.id
   cidr_block        = var.public_subnet1
   availability_zone = var.az1
}

# public subnet 2
resource "aws_subnet" "public_subnet2" {  
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.public_subnet2
  availability_zone = var.az2
}

# private subnet 1
resource "aws_subnet" "private_subnet1" {   
   vpc_id            = aws_vpc.custom_vpc.id
   cidr_block        = var.private_subnet1
   availability_zone = var.az1
}

# private subnet 2
resource "aws_subnet" "private_subnet2" {   
   vpc_id            = aws_vpc.custom_vpc.id
   cidr_block        = var.private_subnet2
   availability_zone = var.az2
}

# creating internet gateway 
resource "aws_internet_gateway" "igw" {
   vpc_id = aws_vpc.custom_vpc.id
}

# creating route table
resource "aws_route_table" "rt" {
   vpc_id = aws_vpc.custom_vpc.id
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
}

# associate route table to the public subnet 1
resource "aws_route_table_association" "public_rt1" {
   subnet_id      = aws_subnet.public_subnet1.id
   route_table_id = aws_route_table.rt.id
}

# associate route table to the public subnet 2
resource "aws_route_table_association" "public_rt2" {
   subnet_id      = aws_subnet.public_subnet2.id
   route_table_id = aws_route_table.rt.id
}

# associate route table to the private subnet 1
resource "aws_route_table_association" "private_rt1" {
   subnet_id      = aws_subnet.private_subnet1.id
   route_table_id = aws_route_table.rt.id
}

# associate route table to the private subnet 2
resource "aws_route_table_association" "private_rt2" {
   subnet_id      = aws_subnet.private_subnet2.id
   route_table_id = aws_route_table.rt.id
}