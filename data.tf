data "aws_availability_zones" "account_available" {
  provider = aws.account-admin
  state    = "available"
}

data "aws_ami" "account_amazon_linux" {
  provider    = aws.account-admin
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "profile_available" {
  provider = aws.profile-admin
  state    = "available"
}

data "aws_ami" "profile_amazon_linux" {
  provider    = aws.profile-admin
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "statement_available" {
  provider = aws.statement-admin
  state    = "available"
}

data "aws_ami" "statement_amazon_linux" {
  provider    = aws.statement-admin
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}