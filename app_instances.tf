resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Security group for application instances"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "app-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "allow_alb_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app.id
  source_security_group_id = aws_security_group.alb.id
  description              = "Allow HTTP from ALB"
}

resource "aws_security_group_rule" "allow_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app.id
  source_security_group_id = aws_security_group.bastion.id
  description              = "Allow SSH from bastion"
}

resource "aws_instance" "app_01" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.app_01.id
  vpc_security_group_ids = [aws_security_group.app.id]
  associate_public_ip_address = false

  tags = {
    Name        = "app-01-instance"
    Environment = var.environment
  }
}

resource "aws_instance" "app_02" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.app_02.id
  vpc_security_group_ids = [aws_security_group.app.id]
  associate_public_ip_address = false

  tags = {
    Name        = "app-02-instance"
    Environment = var.environment
  }
}

resource "aws_lb_target_group_attachment" "app_01" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.app_01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_02" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.app_02.id
  port             = 80
}
