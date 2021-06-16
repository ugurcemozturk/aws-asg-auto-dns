import json
import boto3
import os

HOSTED_ZONE_ID = os.environ['HOSTED_ZONE_ID']
DNS_RECORD_NAME = os.environ['DNS_RECORD_NAME']
TTL = os.environ['TTL']

route53 = boto3.client('route53')


# TODO: Move common functions to the lambda layers
def get_public_ip(event):
    """Get the public IP of an EC2 by its instance ID"""
    try:
        ec2 = boto3.resource('ec2')
        instance_id = json.loads(event["Records"][0]["Sns"]["Message"])[
            "EC2InstanceId"]
        instance = ec2.Instance(instance_id)
        public_ip = instance.public_ip_address
        print(f'Provisioned public IP: {public_ip}')
        return public_ip
    except Exception as e:
        print(f'Cannot get public IP: {e}')
        raise e


def create_change_set(public_ip):
    """Create changeSet by given IP of the just provisioned EC2 instance"""
    try:
        change_set = {
            'Changes': [
                {
                    'Action': 'CREATE',
                    'ResourceRecordSet': {
                        'Name': DNS_RECORD_NAME,
                        'Type': 'A',
                        'SetIdentifier': public_ip,
                        'MultiValueAnswer': True,
                        'TTL': int(TTL),
                        'ResourceRecords': [
                            {
                                'Value': public_ip
                            },
                        ]
                    }
                }
            ]
        }
        return change_set
    except Exception as e:
        print(f'Cannot create change set: {e}')
        raise e


def add_multivalue_dns(public_ip):
    """Create a new multivalue routed A record for given domain name"""
    try:
        change_response = route53.change_resource_record_sets(
            HostedZoneId=HOSTED_ZONE_ID,
            ChangeBatch=create_change_set(public_ip)
        )
        return change_response
    except Exception as e:
        print(f'Cannot add DNS entry: {e}')
        raise e


def lambda_handler(event, context):
    try:
        public_ip = get_public_ip(event)
        change_response = add_multivalue_dns(public_ip)
        print(change_response)
        return True
    except Exception as e:
        print(
            f'Internal server error. Check logs at: {context.log_group_name}')
        raise e
