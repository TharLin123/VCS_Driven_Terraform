output "account_alb_dns_name" {
  description = "DNS name of the account application load balancer"
  value       = aws_lb.account.dns_name
}