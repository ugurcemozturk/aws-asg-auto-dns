resource "aws_launch_template" "this" {
  name        = format("%s-lt", var.service_name)
  description = format("%s launch template", var.service_name)

  disable_api_termination              = true
  ebs_optimized                        = true
  image_id                             = data.aws_ami.this.id
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = var.iam_profile
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.this.id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.disk_volume_size_in_GB
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

  tags = { // duplicate with instance tags?
    Name    = format("%s-lt", var.service_name)
    Service = var.service_name
  }
}
