#!/bin/sh

aws iam create-policy \
 --policy-name TfUserPolicy \
 --policy-document file:///home/ansible/aws-terrraform-ansible/TfUserPolicy.json

terraform_policy_arn=$(aws iam list-policies --query 'Policies[?PolicyName==`"TfUserPolicy"`].Arn' --output text)
aws iam create-user --user-name terraform

aws iam attach-user-policy --policy-arn $(terraform_policy_arn) --user-name terraform


aws s3api create-bucket --bucket terraformstatefile2022