output "vpc_id" {
  description = "ID of the profile VPC"
  value       = aws_vpc.profile.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.profile_public.id
}

output "public_subnet_secondary_id" {
  description = "ID of the secondary public subnet"
  value       = aws_subnet.profile_public_secondary.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.profile_private.id
}

# output "bastion_public_ip" {
#   description = "Public IP address of the bastion host"
#   value       = aws_instance.bastion.public_ip
# }

# # Expose the private key as a sensitive Terraform output
# output "bastion_private_key" {
#   value     = tls_private_key.bastion.private_key_pem
#   sensitive = true
# }