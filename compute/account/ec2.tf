resource "aws_instance" "account_bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.account_bastion_public.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.account_bastion.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/../../user_data.sh", {
    bastion_private_key = tls_private_key.account_bastion_private.private_key_pem
  })

  tags = {
    Name = "account-bastion"
  }
}

resource "aws_instance" "account" {
  count                       = 2
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.account_public.key_name
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.account.id]
  associate_public_ip_address = false

  tags = {
    Name = "account-ec2-${count.index + 1}"
  }
}