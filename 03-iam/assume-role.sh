#!/bin/bash
export AWS_ACCESS_KEY_ID=$(cat tmp_creds.json | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(cat tmp_creds.json | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(cat tmp_creds.json | jq -r '.Credentials.SessionToken')

rm tmp_creds.json