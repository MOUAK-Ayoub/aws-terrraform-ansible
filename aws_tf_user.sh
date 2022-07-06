#!/bin/bash

aws iam create-policy \
 --policy-name TfUserPolicy \
 --policy-document file:///home/ansible/aws-terrraform-ansible/TfUserPolicy.json
 
 sleep 5s

terraform_policy_arn=$(aws iam list-policies --query 'Policies[?PolicyName==`"TfUserPolicy"`].Arn' --output text)
aws iam create-user --user-name terraform

sleep 5s

aws iam attach-user-policy --policy-arn $terraform_policy_arn --user-name terraform
sleep 5s

aws s3api create-bucket --bucket terraformstatefile2022