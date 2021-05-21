#!/bin/bash
ACC_ID=324320755747
USER_ID=brandon.garcia.labs
TOKEN=$1

aws sts get-session-token --serial-number arn:aws:iam::$ACC_ID:mfa/$USER_ID --token-code $TOKEN > tmp_creds.json

export AWS_ACCESS_KEY_ID=$(cat tmp_creds.json | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(cat tmp_creds.json | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(cat tmp_creds.json | jq -r '.Credentials.SessionToken')

rm tmp_creds.json