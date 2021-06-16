# Description

This terraform template creates an AWS **Auto Scaling Group** with network based **scaling policy** and their **CloudWatch alarms** among with auto DNS updates on instance start and terminate by sending notifications from **Auto Scaling Group lifecycle hooks** to **SNS**. This SNS notifications trigger python based **lambda functions** to update your DNS entities hosted in **Route53**

## It's highly recommended to use AWS managed or custom load balancer. This implementation relies on the Route53 MultiValueAnswer policy.
This implementation may cover your needs when you cannot work with a load balancer due to specific network protocols or such. It applies DNS round-robin by using Route53 MultiValueAnswer policy.

## Requirements
You have to edit `variables.tfvars`, especially the ones with `your-###` such as AMI name, VPC name, etc.

## What's being provisioned?
- It deploys to your default VPC in eu-central-1 region which can be configured in `variables.tfvars`
- An Auto Scaling Group with 2 desired instances with the launch template defined below
- A launch template with the most recent Amazon Linux 2 AMI; `amzn2-ami-hvm*`
- 2 scaling policy and cloudwatch alarms that trigger based on networkOut metric of the ASG instances.
- A security group with one TCP ingress, the ingress port defined as a terraform variable.
- 2 Lambda functions to register and deregister DNS
- 2 SNS topics to trigger register and deregister Lamdas
- An IAM role for lambda funciton to let them update the DNS (!! This is shitty, it uses AdministratorPolicy and needs to be updated by least privillaged scope !!)
- It's not using S3 or any other backend as a state management for the sake of the POC.

## Todo
- [ ] Replace Admin level policy
- [ ] Estimated cost
- [ ] Add architecture diagram
- [ ] Lamda layers