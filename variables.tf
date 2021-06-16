variable "region" {
  description = "AWS region of the service to be deployed"
  type        = string
}

variable "service_name" {
  description = "Name of service"
  type        = string
}

variable "service_port" {
  description = "Ingress port of the service"
  type        = number
}

variable "desired_capacity" {
  description = "Desired instance number for asg"
  type        = number
}

variable "min_size" {
  description = "Minimum instance number for an asg"
  type        = number
}

variable "max_size" {
  description = "Maximum instance number for an asg"
  type        = string
}

variable "default_cooldown" {
  description = "Default cooldown value for each check"
  type        = number
}

variable "health_check_grace_period" {
  description = "health check grace period in seconds."
  type        = number
  default     = 180
}

variable "health_check" {
  description = "ASG Health Check Type"
  type        = string
}

variable "disk_volume_size_in_GB" {
  description = "Size of the EBS volume."
  type        = number
}

variable "iam_profile" {
  description = "IAM role of the instance."
  type        = string
}

variable "instance_type" {
  description = "Type of the EC2 instance."
  type        = string
}

variable "key_name" {
  description = "EC2 Key pair name."
  type        = string
}

variable "dns_record_name" {
  description = "Domain name of the instance to be registered"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "ttl" {
  description = "TTL for DNS cache"
  type        = number
}

variable "scale_up_networkIn_threshold_in_bytes" {
  description = "Scale up threshold metric by incoming network bytes"
  type        = number
}

variable "scale_down_networkIn_threshold_in_bytes" {
  description = "Scale down threshold metric by incoming network bytes"
  type        = number
}
