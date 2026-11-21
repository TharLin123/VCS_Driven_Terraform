terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.account,
        aws.profile,
        aws.statement,
      ]
    }
  }
}

resource "aws_vpc_peering_connection" "account_profile" {
  provider      = aws.account
  vpc_id        = var.account_vpc_id
  peer_vpc_id   = var.profile_vpc_id
  peer_owner_id = var.profile_owner_id
  peer_region   = var.profile_region

  tags = {
    Name = "account-profile-peering"
  }
}

resource "aws_vpc_peering_connection_accepter" "account_profile" {
  provider                  = aws.profile
  vpc_peering_connection_id = aws_vpc_peering_connection.account_profile.id
  auto_accept               = true

  tags = {
    Name = "account-profile-peering"
  }
}

resource "aws_vpc_peering_connection" "profile_statement" {
  provider      = aws.profile
  vpc_id        = var.profile_vpc_id
  peer_vpc_id   = var.statement_vpc_id
  peer_owner_id = var.statement_owner_id
  peer_region   = var.statement_region

  tags = {
    Name = "profile-statement-peering"
  }
}

resource "aws_vpc_peering_connection_accepter" "profile_statement" {
  provider                  = aws.statement
  vpc_peering_connection_id = aws_vpc_peering_connection.profile_statement.id
  auto_accept               = true

  tags = {
    Name = "profile-statement-peering"
  }
}

resource "aws_route" "account_public_to_profile" {
  provider                  = aws.account
  route_table_id            = var.account_public_route_table_id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.account_profile.id
  depends_on                = [aws_vpc_peering_connection_accepter.account_profile]
}

resource "aws_route" "account_private_to_profile" {
  provider                  = aws.account
  route_table_id            = var.account_private_route_table_id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.account_profile.id
  depends_on                = [aws_vpc_peering_connection_accepter.account_profile]
}

resource "aws_route" "profile_public_to_account" {
  provider                  = aws.profile
  route_table_id            = var.profile_public_route_table_id
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.account_profile.id
  depends_on                = [aws_vpc_peering_connection_accepter.account_profile]
}

resource "aws_route" "profile_private_to_account" {
  provider                  = aws.profile
  route_table_id            = var.profile_private_route_table_id
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.account_profile.id
  depends_on                = [aws_vpc_peering_connection_accepter.account_profile]
}

resource "aws_route" "profile_public_to_statement" {
  provider                  = aws.profile
  route_table_id            = var.profile_public_route_table_id
  destination_cidr_block    = "10.2.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.profile_statement.id
  depends_on                = [aws_vpc_peering_connection_accepter.profile_statement]
}

resource "aws_route" "profile_private_to_statement" {
  provider                  = aws.profile
  route_table_id            = var.profile_private_route_table_id
  destination_cidr_block    = "10.2.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.profile_statement.id
  depends_on                = [aws_vpc_peering_connection_accepter.profile_statement]
}

resource "aws_route" "statement_public_to_profile" {
  provider                  = aws.statement
  route_table_id            = var.statement_public_route_table_id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.profile_statement.id
  depends_on                = [aws_vpc_peering_connection_accepter.profile_statement]
}

resource "aws_route" "statement_private_to_profile" {
  provider                  = aws.statement
  route_table_id            = var.statement_private_route_table_id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.profile_statement.id
  depends_on                = [aws_vpc_peering_connection_accepter.profile_statement]
}