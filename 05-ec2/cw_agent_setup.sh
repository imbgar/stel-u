#!/bin/bash
mkdir /work

# prep_cw_agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
curl https://us-east-1-324320755747-elpollolocodude.s3.amazonaws.com/config.json -o config.json
apt-get update

# install_collectd
apt-get install collectd -y

# install_cw_agent
dpkg -i -E ./amazon-cloudwatch-agent.deb

# run_cw_agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/work/config.json