## Lambda log groups
resource "aws_cloudwatch_log_group" "dns_register" {
  name              = "/aws/lambda/dns_register"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "dns_deregister" {
  name              = "/aws/lambda/dns_deregister"
  retention_in_days = 30
}


## Scaling alarms
resource "aws_cloudwatch_metric_alarm" "network-high" {
  alarm_name          = format("%s-network-high", var.service_name)
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.scale_up_networkIn_threshold_in_bytes
  alarm_description   = format("Monitors %s instance network for high utilization.", var.service_name)
  alarm_actions       = [aws_autoscaling_policy.up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}

resource "aws_cloudwatch_metric_alarm" "memory-low" {
  alarm_name          = format("%s-network-low", var.service_name)
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.scale_down_networkIn_threshold_in_bytes
  alarm_description   = format("Monitors %s instance network for low utilization.", var.service_name)
  alarm_actions       = [aws_autoscaling_policy.down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}
