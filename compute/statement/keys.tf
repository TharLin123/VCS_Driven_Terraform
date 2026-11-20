# Generate a new private/public key pair
resource "tls_private_key" "statement_bastion_private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "statement_bastion_public" {
  key_name   = "bastion-key"
  public_key = tls_private_key.statement_bastion_private.public_key_openssh
}

# Generate a new private/public key pair
resource "tls_private_key" "statement_private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "statement_public" {
  key_name   = "statement-key"
  public_key = tls_private_key.statement_private.public_key_openssh
}