resource "aws_lb" "profile" {
  name               = "profile-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = [var.public_subnet_id, var.public_subnet_secondary_id]
  security_groups    = [aws_security_group.profile_alb.id]

  tags = {
    Name = "profile-alb"
  }
}

resource "aws_lb_target_group" "profile" {
  name     = "profile-tg"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    port     = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "profile" {
  count            = length(aws_instance.profile)
  target_group_arn = aws_lb_target_group.profile.arn
  target_id        = aws_instance.profile[count.index].id
  port             = 9090
}

resource "aws_lb_listener" "profile_http" {
  load_balancer_arn = aws_lb.profile.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.profile.arn
  }
}