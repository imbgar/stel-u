from yaml.loader import SafeLoader
import boto3
import yaml
import argparse
import json

## Usage python3 stack-mgmt.py --action delete --stack_name bgarlab13 --template_file template.yml --parameters_file parameters.json
## Relies on relative path unless you specify the absolute path, didn't feel like implementing abspath :p

def apply_stack(client, template_body, stack_name, parameters, capability) -> None:
    if _stack_exists(client, stack_name):
        response = client.update_stack(
            StackName=stack_name,
            TemplateBody=template_body,
            Parameters=parameters,
            Capabilities=[capability]
        )
    else:
        response = client.create_stack(
            StackName=stack_name,
            TemplateBody=template_body,
            Parameters=parameters,
            Capabilities=[capability]
        )

def delete_stack(client, stack_name) -> None:
    response = client.delete_stack(
    StackName=stack_name
    )

def _stack_exists(client, stack_name):
    stacks = client.list_stacks()['StackSummaries']
    for stack in stacks:
        if stack['StackStatus'] == 'DELETE_COMPLETE':
            continue
        if stack_name == stack['StackName']:
            return True
    return False

def _init():
    global template
    global regions
    global parameters
    global args

    parser = argparse.ArgumentParser(description='Allows for parameterization of execution')

    parser.add_argument('--action', type=str,
                        help='the action you wish to perform against the stack. apply or delete', required=True)

    parser.add_argument('--stack_name', type=str,
                        help='the stack you wish to perform the action against', required=True)

    parser.add_argument('--template_file', type=str,
                        help='the template you wish to deploy', required=True)

    parser.add_argument('--parameters_file', type=str,
                        help='the parameters you wish to specify', required=True)

    parser.add_argument('--capability', type=str,
                        help='the template you wish to deploy', required=False, default="CAPABILITY_NAMED_IAM")

    args = parser.parse_args()

    with open(args.template_file) as f:
        template = f.read()

    with open('regions.yml') as f:
        regions = yaml.load(f, Loader=SafeLoader)

    with open(args.parameters_file) as f:
        parameters = json.load(f)

if __name__ == "__main__":
    _init()
    if args.action == 'apply':
        for region in regions:
            client = boto3.client('cloudformation', region_name=region)
            apply_stack(client, template, args.stack_name, parameters, args.capability)

    if args.action == 'delete':
        for region in regions:
            client = boto3.client('cloudformation', region_name=region)
            delete_stack(client, args.stack_name)
