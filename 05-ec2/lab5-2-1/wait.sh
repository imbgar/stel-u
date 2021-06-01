#!/bin/bash
aws cloudformation create-stack --template-body file://template.yml --parameter file://parameters.json --stack-name $1

aws cloudformation wait stack-create-complete --stack-name $1

echo "Stack:$1 create complete"