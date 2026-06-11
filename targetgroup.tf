resource "aws_lb_target_group" "app" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    matcher             = "200"
  }

  tags = {
    Name        = "app-tg"
    Environment = var.environment
  }
}

resource "aws_lb_target_group_attachment" "app_01" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app_01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_02" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app_02.id
  port             = 80
}
