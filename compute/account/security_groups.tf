resource "aws_security_group" "account_bastion" {
  name        = "account-bastion"
  description = "Allow SSH to the account bastion"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "account-bastion"
  }
}

resource "aws_security_group" "account" {
  name        = "account-ec2"
  description = "Allow SSH from bastion and application traffic from the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from bastion"
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.account_bastion.id]
  }

  ingress {
    description     = "HTTP application traffic from the ALB"
    protocol        = "tcp"
    from_port       = 9090
    to_port         = 9090
    security_groups = [aws_security_group.account_alb.id]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [var.profile_vpc_cidr]
  }

  tags = {
    Name = "account-ec2"
  }
}

resource "aws_security_group" "account_alb" {
  name        = "account-alb"
  description = "Allow HTTP from anywhere to the account ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "account-alb"
  }
}

resource "aws_vpc_security_group_egress_rule" "alb_to_account" {
  security_group_id            = aws_security_group.account_alb.id
  referenced_security_group_id = aws_security_group.account.id

  ip_protocol = "tcp"
  from_port   = 9090
  to_port     = 9090

  description = "Allow HTTP to Account EC2"
}