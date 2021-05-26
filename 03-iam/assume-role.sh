#!/bin/bash

aws sts assume-role --role-arn arn:aws:iam::324320755747:role/$1 --role-session-name "rolesesh1"  > tmp_creds.json

export AWS_ACCESS_KEY_ID=$(cat tmp_creds.json | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(cat tmp_creds.json | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(cat tmp_creds.json | jq -r '.Credentials.SessionToken')

rm tmp_creds.json