terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  alias   = "account-admin"
  region  = var.account_region
  profile = var.account_profile
  # access_key = var.AWS_ACCESS_KEY_ID_ACCOUNT
  # secret_key = var.AWS_SECRET_ACCESS_KEY_ACCOUNT
}


provider "aws" {
  alias   = "profile-admin"
  region  = var.profile_region
  profile = var.profile_profile
  # access_key = var.AWS_ACCESS_KEY_ID_PROFILE
  # secret_key = var.AWS_SECRET_ACCESS_KEY_PROFILE
}

provider "aws" {
  alias   = "statement-admin"
  region  = var.statement_region
  profile = var.statement_profile
  # access_key = var.AWS_ACCESS_KEY_ID_STATEMENT
  # secret_key = var.AWS_SECRET_ACCESS_KEY_STATEMENT
}

module "account_networking" {
  source             = "./networking/account"
  availability_zones = data.aws_availability_zones.account_available.names

  providers = {
    aws = aws.account-admin
  }
}

module "account_compute" {
  source                     = "./compute/account"
  ami_id                     = data.aws_ami.account_amazon_linux.id
  vpc_id                     = module.account_networking.vpc_id
  private_subnet_id          = module.account_networking.private_subnet_id
  public_subnet_id           = module.account_networking.public_subnet_id
  public_subnet_secondary_id = module.account_networking.public_subnet_secondary_id
  profile_vpc_cidr           = module.profile_networking.vpc_cidr_block

  providers = {
    aws = aws.account-admin
  }
}

module "profile_networking" {
  source             = "./networking/profile"
  availability_zones = data.aws_availability_zones.profile_available.names

  providers = {
    aws = aws.profile-admin
  }
}

module "profile_compute" {
  source                     = "./compute/profile"
  ami_id                     = data.aws_ami.profile_amazon_linux.id
  vpc_id                     = module.profile_networking.vpc_id
  private_subnet_id          = module.profile_networking.private_subnet_id
  public_subnet_id           = module.profile_networking.public_subnet_id
  public_subnet_secondary_id = module.profile_networking.public_subnet_secondary_id
  statement_vpc_cidr         = module.statement_networking.vpc_cidr_block

  providers = {
    aws = aws.profile-admin
  }
}

module "statement_networking" {
  source             = "./networking/statement"
  availability_zones = data.aws_availability_zones.statement_available.names

  providers = {
    aws = aws.statement-admin
  }
}

module "statement_compute" {
  source                     = "./compute/statement"
  ami_id                     = data.aws_ami.statement_amazon_linux.id
  vpc_id                     = module.statement_networking.vpc_id
  private_subnet_id          = module.statement_networking.private_subnet_id
  public_subnet_id           = module.statement_networking.public_subnet_id
  public_subnet_secondary_id = module.statement_networking.public_subnet_secondary_id

  providers = {
    aws = aws.statement-admin
  }
}

module "vpc_peering" {
  source = "./networking"

  account_vpc_id                   = module.account_networking.vpc_id
  profile_vpc_id                   = module.profile_networking.vpc_id
  statement_vpc_id                 = module.statement_networking.vpc_id
  account_public_route_table_id    = module.account_networking.public_route_table_id
  account_private_route_table_id   = module.account_networking.private_route_table_id
  profile_public_route_table_id    = module.profile_networking.public_route_table_id
  profile_private_route_table_id   = module.profile_networking.private_route_table_id
  statement_public_route_table_id  = module.statement_networking.public_route_table_id
  statement_private_route_table_id = module.statement_networking.private_route_table_id
  profile_owner_id                 = data.aws_caller_identity.profile.account_id
  statement_owner_id               = data.aws_caller_identity.statement.account_id
  profile_region                   = var.profile_region
  statement_region                 = var.statement_region

  providers = {
    aws.account   = aws.account-admin
    aws.profile   = aws.profile-admin
    aws.statement = aws.statement-admin
  }
}

# scp -i ~/.ssh/private-key.pem fake-service ec2-user@:/home/ec2-user