output "profile_alb_dns_name" {
  description = "DNS name of the profile application load balancer"
  value       = aws_lb.profile.dns_name
}