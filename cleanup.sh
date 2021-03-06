#!/bin/bash

echo "############################"
echo "# Executing cleanup script #"
echo "############################"

echo "----------------------------------------------------------"
echo "Step 1. Delete ProductManagerService CloudFormation stack "
echo "----------------------------------------------------------"

echo "--------------------------------"
echo "Step 1.1 Deal with dependancies "
echo "--------------------------------"


echo "----------------------------------------------------------"
echo "Step 2. Delete ECR Repo created in this stack             "
echo "----------------------------------------------------------"

echo "----------------------------------------------------------"
echo "Step 3. Delete S3 All bucket                              "
echo "----------------------------------------------------------"
echo "------------------"
echo "Deleting S3 Bucket with aws-saas-factory-bootcamp prefix in your region"
echo "------------------"


for bucket in $(aws s3 ls | awk '{print $3}' | grep aws-saas-factory-bootcamp)
do 
    echo 'Deleting '${bucket}
    bash ./deletever.sh ${bucket}
    aws s3 rm --recursive s3://${bucket}
    aws s3 rb --force s3://${bucket}
done

echo "--------------------------------------------------"
echo "Step 4. Delete Parent Stack                       "
echo "--------------------------------------------------"

echo "--------------------------------"
echo "Step 4.1 Deal with dependancies "
echo "--------------------------------"
