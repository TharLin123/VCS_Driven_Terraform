# Generate a new private/public key pair
resource "tls_private_key" "profile_bastion_private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "profile_bastion_public" {
  key_name   = "bastion-key"
  public_key = tls_private_key.profile_bastion_private.public_key_openssh
}

# Generate a new private/public key pair
resource "tls_private_key" "profile_private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "profile_public" {
  key_name   = "profile-key"
  public_key = tls_private_key.profile_private.public_key_openssh
}