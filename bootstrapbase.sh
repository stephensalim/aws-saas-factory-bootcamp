#!/bin/bash

echo "#######################################"
echo "# Executing baseline bootstrap script #"
echo "#######################################"

echo "Creating S3 Bucket"
aws s3 mb s3://$1

echo "Copying bootcamp Base files"
aws s3 cp --recursive Base/ s3://$1/bootcamp/Base

aws cloudformation create-stack --stack-name aws-saas-factory-bootcamp \
                                --template-body file://templates/saas-bootcamp-baseline-master.template \
                                --capabilities CAPABILITY_NAMED_IAM  CAPABILITY_IAM \
                                --disable-rollback \
                                --parameters "ParameterKey"="QSS3BucketName","ParameterValue"=$1 "ParameterKey"="QSS3KeyPrefix","ParameterValue"="bootcamp/" --region $2
