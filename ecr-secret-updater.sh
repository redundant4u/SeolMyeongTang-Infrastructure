#!/bin/sh
# 0 */10 * * * ecr-secret-updater.sh

set -e

NAMESPACE=smt-dev

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=$(aws configure get region)

ECR_PASSWORD=$(aws ecr get-login-password --region ${AWS_REGION})

kubectl create secret docker-registry ecr-secret \
  --docker-server=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com \
  --docker-username=AWS \
  --docker-password="${ECR_PASSWORD}" \
  --namespace ${NAMESPACE} \
  --dry-run=client -o yaml \
| kubectl apply -f -
