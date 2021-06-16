resource "aws_autoscaling_group" "this" {
  name                      = format("%s-asg", var.service_name)
  vpc_zone_identifier       = data.aws_subnet_ids.all.ids
  health_check_type         = var.health_check
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  default_cooldown          = var.default_cooldown
  health_check_grace_period = var.health_check_grace_period
  termination_policies      = tolist(["OldestLaunchTemplate"])
  wait_for_capacity_timeout = "30m"

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"

  }

  lifecycle {
    create_before_destroy = true
  }

  initial_lifecycle_hook {
    name                    = "register-dns"
    default_result          = "CONTINUE"
    heartbeat_timeout       = 40
    lifecycle_transition    = "autoscaling:EC2_INSTANCE_LAUNCHING"
    notification_target_arn = aws_sns_topic.dns_register_topic.arn
    role_arn                = aws_iam_role.sns_role.arn
  }

  initial_lifecycle_hook {
    name                    = "deregister-dns"
    default_result          = "CONTINUE"
    heartbeat_timeout       = 40
    lifecycle_transition    = "autoscaling:EC2_INSTANCE_TERMINATING"
    notification_target_arn = aws_sns_topic.dns_deregister_topic.arn
    role_arn                = aws_iam_role.sns_role.arn
  }
  timeouts {
    delete = "25m"
  }
}

## Scale-up policy
resource "aws_autoscaling_policy" "up" {
  name                   = format("%s-scale-up", var.service_name)
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.this.name
}


## Scale-down policy
resource "aws_autoscaling_policy" "down" {
  name                   = format("%s-scale-down", var.service_name)
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.this.name
}
