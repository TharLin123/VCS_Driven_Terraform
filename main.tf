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
  # profile = var.account_profile
  access_key = var.AWS_ACCESS_KEY_ID_ACCOUINT
  secret_key = var.AWS_SECRET_ACCESS_KEY_ACCOUNT
}


provider "aws" {
  alias   = "profile-admin"
  region  = var.profile_region
  # profile = var.profile_profile
  access_key = var.AWS_ACCESS_KEY_ID_PROFILE
  secret_key = var.AWS_SECRET_ACCESS_KEY_PROFILE
}

provider "aws" {
  alias   = "statement-admin"
  region  = var.statement_region
  # profile = var.statement_profile
  access_key = var.AWS_ACCESS_KEY_ID_STATEMENT
  secret_key = var.AWS_SECRET_ACCESS_KEY_STATEMENT
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




# create vpc peering between account_vpc and profile vpc, create vpc peering between profile_vpc and statement_vpc in networking/vpc_peering.tf