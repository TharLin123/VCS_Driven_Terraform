resource "aws_lb" "account" {
  name               = "account-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = [var.public_subnet_id, var.public_subnet_secondary_id]
  security_groups    = [aws_security_group.account_alb.id]

  tags = {
    Name = "account-alb"
  }
}

resource "aws_lb_target_group" "account" {
  name     = "account-tg"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    port     = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "account" {
  count            = length(aws_instance.account)
  target_group_arn = aws_lb_target_group.account.arn
  target_id        = aws_instance.account[count.index].id
  port             = 9090
}

resource "aws_lb_listener" "account_http" {
  load_balancer_arn = aws_lb.account.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.account.arn
  }
}