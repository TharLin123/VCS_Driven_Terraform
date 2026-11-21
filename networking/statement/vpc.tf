resource "aws_vpc" "statement" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "statement-vpc"
  }
}

resource "aws_subnet" "statement_public" {
  vpc_id                  = aws_vpc.statement.id
  cidr_block              = "10.2.1.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "statement-vpc-public"
  }
}

resource "aws_subnet" "statement_public_secondary" {
  vpc_id                  = aws_vpc.statement.id
  cidr_block              = "10.2.3.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "statement-vpc-public"
  }
}

resource "aws_subnet" "statement_private" {
  vpc_id            = aws_vpc.statement.id
  cidr_block        = "10.2.2.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "statement-vpc-private"
  }
}

resource "aws_internet_gateway" "statement_igw" {
  vpc_id = aws_vpc.statement.id

  tags = {
    Name = "statement-vpc-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.statement.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.statement_igw.id
  }

  tags = {
    Name = "statement-vpc-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.statement_public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_secondary" {
  subnet_id      = aws_subnet.statement_public_secondary.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.statement.id

  tags = {
    Name = "statement-vpc-private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.statement_private.id
  route_table_id = aws_route_table.private.id
}