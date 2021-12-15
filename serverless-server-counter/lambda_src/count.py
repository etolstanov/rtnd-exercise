import json
import boto3

ec2 = boto3.resource('ec2')

def get_running_ec2_instances():
    filter = [{
        'Name': 'instance-state-name',
        'Values': ['running']
    }]

    return ec2.instances.filter(Filters = filter)

def lambda_handler(event, context):
    dict = {}
    #first we classify running instances based on their type and count them
    for instance in get_running_ec2_instances():
        if not instance.instance_type in dict:
            dict[instance.instance_type] = 0

        dict[instance.instance_type] += 1

    #then we use a list to provide the desired output format
    #[{'type': 'w', 'count': x}, {'type': 'y', 'count': z},...]
    out = []
    for k,v in dict.items():
        out.append({'type': k, 'count': v})

    #finally return list in json format
    return json.dumps(out)
