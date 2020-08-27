#!/bin/bash

echo "#######################################"
echo "# Executing baseline bootstrap script #"
echo "#######################################"

echo "--------------------------"
echo "Step 1. Creating S3 Bucket"
echo "--------------------------"
aws s3 mb s3://$1

echo "-----------------------------"
echo "Step2. Copying bootcamp files"
echo "-----------------------------"
aws s3 cp --recursive Base/ s3://$1/bootcamp/Base
aws s3 cp --recursive Lab1/ s3://$1/bootcamp/Lab1
aws s3 cp --recursive Lab2/ s3://$1/bootcamp/Lab2
aws s3 cp --recursive Lab3/ s3://$1/bootcamp/Lab3


echo "-------------------------------"
echo "Step3. Executing Baseline Stack"
echo "-------------------------------"
aws cloudformation create-stack --stack-name aws-saas-factory-bootcamp \
                                --template-body file://templates/saas-bootcamp-baseline-master.template \
                                --capabilities CAPABILITY_NAMED_IAM  CAPABILITY_IAM \
                                --disable-rollback \
                                --parameters "ParameterKey"="QSS3BucketName","ParameterValue"=$1 "ParameterKey"="QSS3KeyPrefix","ParameterValue"="bootcamp/" --region $2

echo "---------------------------------"
echo "Step4. Wait for Stack to Complete"
echo "---------------------------------"
STATUS=$(aws cloudformation describe-stacks --region $2 --stack-name aws-saas-factory-bootcamp --query 'Stacks[0].StackStatus')
count=0
while [ $STATUS == "CREATE_IN_PROGRESS" ]
do
    ((count=count+1))

    echo ">> Checking Status every 5 mins #$count <<"
    aws cloudformation describe-stack-events --region $2 \
                                         --stack-name aws-saas-factory-bootcamp \
                                         --output text \
                                         --query 'StackEvents[*].[ResourceStatus,LogicalResourceId,ResourceType,Timestamp]'
    sleep 60
done