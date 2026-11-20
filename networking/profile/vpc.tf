resource "aws_vpc" "profile" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "profile-vpc"
  }
}

resource "aws_subnet" "profile_public" {
  vpc_id                  = aws_vpc.profile.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "profile-vpc-public"
  }
}

resource "aws_subnet" "profile_public_secondary" {
  vpc_id                  = aws_vpc.profile.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "profile-vpc-public"
  }
}

resource "aws_subnet" "profile_private" {
  vpc_id            = aws_vpc.profile.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "profile-vpc-private"
  }
}

resource "aws_internet_gateway" "profile_igw" {
  vpc_id = aws_vpc.profile.id

  tags = {
    Name = "profile-vpc-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.profile.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.profile_igw.id
  }

  tags = {
    Name = "profile-vpc-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.profile_public.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.profile.id

  tags = {
    Name = "profile-vpc-private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.profile_private.id
  route_table_id = aws_route_table.private.id
}