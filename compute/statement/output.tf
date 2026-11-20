output "statement_alb_dns_name" {
  description = "DNS name of the statement application load balancer"
  value       = aws_lb.statement.dns_name
}