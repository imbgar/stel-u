#!/bin/bash

yq e '.[]' regions.yml| while read region
do
   aws cloudformation create-stack --stack-name testbucketbgar --template-body file://./template.yml --region $region
done
