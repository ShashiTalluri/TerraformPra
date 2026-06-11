resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/aws/nginx/app"
  retention_in_days = 14

  tags = {
    Name        = "nginx-log-group"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  for_each = toset([aws_instance.app_01.id, aws_instance.app_02.id])

  alarm_name          = "high-cpu-${each.value}"
  alarm_description   = "Triggers when CPU usage > 70% for 2 consecutive periods"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  dimensions = {
    InstanceId = each.value
  }

  alarm_actions = []
  ok_actions    = []
}
