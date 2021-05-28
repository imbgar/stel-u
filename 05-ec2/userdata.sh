#!/bin/bash
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
apt-get update
apt-get install collectd -y
mkdir /check
cd /check
curl https://us-east-1-324320755747-elpollolocodude.s3.amazonaws.com/config.json -o config.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/check/config.json