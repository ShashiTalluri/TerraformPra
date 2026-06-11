

resource "aws_instance" "app_01" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.app_01.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ssm.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable nginx1
              yum install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "Hello from app_01" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name        = "app-01-instance"
    Environment = var.environment
  }
}

resource "aws_instance" "app_02" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.app_02.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable nginx1
              yum install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "Hello from app_02" > /usr/share/nginx/html/index.html
              EOF

  iam_instance_profile = aws_iam_instance_profile.ssm.name

  tags = {
    Name        = "app-02-instance"
    Environment = var.environment
  }
}


