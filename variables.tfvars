# Common
service_port = 80
service_name = "your-service-name"
region       = "eu-central-1"

# ASG
desired_capacity                        = 2
min_size                                = 1
max_size                                = 5
default_cooldown                        = 1
health_check_grace_period               = 120
scale_up_networkIn_threshold_in_bytes   = 5000000 # 5MB
scale_down_networkIn_threshold_in_bytes = 1000000 # 1MB
health_check                            = "EC2"

# Launch Template
disk_volume_size_in_GB = 20
iam_profile            = "your-iam-role"
key_name               = "your-key-name"
instance_type          = "t2.micro"

# Route53
ttl             = 1
hosted_zone_id  = "your-hosted-zone-id"
dns_record_name = "your.fqdn.com"
