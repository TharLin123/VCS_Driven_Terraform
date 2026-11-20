resource "aws_lb" "statement" {
  name               = "statement-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.public_subnet_id, var.public_subnet_secondary_id]
  security_groups    = [aws_security_group.statement_alb.id]

  tags = {
    Name = "statement-alb"
  }
}

resource "aws_lb_target_group" "statement" {
  name     = "statement-tg"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    port     = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "statement" {
  count            = length(aws_instance.statement)
  target_group_arn = aws_lb_target_group.statement.arn
  target_id        = aws_instance.statement[count.index].id
  port             = 9090
}

resource "aws_lb_listener" "statement_http" {
  load_balancer_arn = aws_lb.statement.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.statement.arn
  }
}