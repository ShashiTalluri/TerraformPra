resource "aws_ami_from_instance" "app_image" {
  name                    = "app-ami-${var.environment}-${replace(timestamp(), ":", "-")}"
  source_instance_id      = "i-0b7a0f2542dcad5ac"
  description             = "AMI created from instance i-0b7a0f2542dcad5ac for ASG"
  snapshot_without_reboot = true

  tags = {
    Name        = "app-ami-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "app-lt-"
  image_id      = aws_ami_from_instance.app_image.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm.name
  }

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(<<-EOF
        #!/bin/bash
        yum update -y
        amazon-linux-extras enable nginx1
        yum install -y nginx
        systemctl enable nginx
        systemctl start nginx
        echo "Hello from ASG instance" > /usr/share/nginx/html/index.html
        EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "app-asg-instance"
      Environment = var.environment
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name             = "app-asg"
  max_size         = 3
  min_size         = 1
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  vpc_zone_identifier = [aws_subnet.app_01.id, aws_subnet.app_02.id]
  target_group_arns   = [aws_lb_target_group.app.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "app-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}
