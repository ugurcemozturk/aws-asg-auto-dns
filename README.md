# Description

This terraform template creates and AWS Auto Scaling Group with network based scaling policy among with auto DNS updates on instance start and terminate by sending notifications from Auto Scaling Group lifecycle hooks to SNS. This SNS notifications trigger python based lambda functions to update your DNS entities hosted in Route53

## It's highly recommended to use AWS managed or custom load balancer. This implementation relies on the Route53 MultiValueAnswer policy.
This implementation may cover your needs when you cannot work with a load balancer due to spesific network protocols or such. It applies DNS round robin by using Route53 MultiValueAnswer policy.

## Requirements
You have to edit `variables.tfvars`, especially the ones with `your-###` such as AMI name, VPC name, etc.

## Todo
- [ ] Estimated cost
- [ ] Lamda layers
- [ ] Replace Admin level policy

