resource "aws_instance" "statement_bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.statement_bastion_public.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.statement_bastion.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/../../user_data.sh", {
    bastion_private_key = tls_private_key.statement_bastion_private.private_key_pem
  })

  tags = {
    Name = "statement-bastion"
  }
}

resource "aws_instance" "statement" {
  count                       = 2
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.statement_public.key_name
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.statement.id]
  associate_public_ip_address = false

  tags = {
    Name = "statement-ec2-${count.index + 1}"
  }
}