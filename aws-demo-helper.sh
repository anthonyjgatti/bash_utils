#!/bin/bash

# Assumes:
# - Install of aws CLI and configured credentials.
# - Install of kubectl and kops

# References:
# https://github.com/kubernetes/kops/blob/master/docs/aws.md

if [ $1 == "prep" ]; then

    # Create group and user for kops, assign policies.
    aws iam create-group --group-name kops

    policies=(AmazonEC2FullAccess AmazonRoute53FullAccess AmazonS3FullAccess IAMFullAccess AmazonVPCFullAccess)
    for i in ${policies[@]}; do
        aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/$i --group-name kops
    done

    aws iam create-user --user-name kops
    aws iam add-user-to-group --user-name kops --group-name kops
    aws iam create-access-key --user-name kops
    aws configure

    export AWS_ACCESS_KEY_ID=`aws configure get aws_access_key_id`
    export AWS_SECRET_ACCESS_KEY=`aws configure get aws_secret_access_key`

    # Spin up EC2 instances.
    aws ec2 create-security-group \
        --group-name sdc-demo \
        --description "Security group for sdc demo."

    aws ec2 authorize-security-group-ingress \
        --group-name sdc-demo \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0

    aws ec2 create-key-pair \
        --key-name sdc-demo-key \
        --query 'KeyMaterial' \
        --output text > sdc-demo-key.pem
    chmod 400 sdc-demo-key.pem

    aws ec2 run-instances \
        --image-id ami-43391926
        --count 1 \
        --instance-type t2.2xlarge
        --key-name sdc-demo-key
        --security-group-ids sg-xxxxxx

# Create S3 bucket to store state.
aws s3api create-bucket \
    --bucket sdc-demo-store-state \
    --region us-east-2 \
    --create-bucket-configuration LocationConstraint=us-east-2

    aws s3api put-bucket-versioning \
        --bucket sdc-demo-store-state \
        --versioning-configuration Status=Enabled

elif [ $1 == "start" ]; then

    # Prepare local environment.
    export NAME=myfirstcluster.k8s.local
    export KOPS_STAT_STORE=s3://sdc-demo-store-state

    # Launch k8s cluster - this can take some time.
    kops create cluster \
        --zones us-east-2 \
        ${NAME}
    kops edit cluster ${NAME}
    kops update cluster ${NAME} --yes

elif [ $1 == "stop" ]; then

    kops delete cluster --name ${NAME} --yes

elif [ $1 == "destroy" ]; then

    aws ec2 terminate-instances --instance-ids xyzxyzxyz

fi
