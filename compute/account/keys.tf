# Generate a new private/public key pair
resource "tls_private_key" "account_bastion_private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "account_bastion_public" {
  key_name   = "bastion-key"
  public_key = tls_private_key.account_bastion_private.public_key_openssh
}

# Generate a new private/public key pair
resource "tls_private_key" "account_private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "account_public" {
  key_name   = "account-key"
  public_key = tls_private_key.account_private.public_key_openssh
}