#!/bin/bash

AWS_REGION="us-west-2"
AWS_ACCOUNT_ID="123456789012"
AWS_REPO_NAME="josephbaruch.com"
LOCAL_REGISTRY="localhost:5000"
TAG="latest"

# Authenticate with AWS ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Pull image from AWS ECR
docker pull $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_REPO_NAME:$TAG

# Tag the image for local registry
docker tag $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_REPO_NAME:$TAG $LOCAL_REGISTRY/$AWS_REPO_NAME:$TAG

# Push image to local registry
docker push $LOCAL_REGISTRY/$AWS_REPO_NAME:$TAG

echo "Image synced successfully!"