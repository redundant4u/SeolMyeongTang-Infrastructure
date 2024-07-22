#!/bin/sh

NAMESPACE=seol
SECRET_NAME=aws-ecr-secret
ACCOUNT=
REGION=ap-northeast-2
TOKEN=`aws ecr --region=$REGION get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`
EMAIL=

cat <<EOF | kubectl replace -f -
apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
  namespace: $NAMESPACE
data:
  .dockerconfigjson: $(echo -n "{\"auths\":{\"https://$ACCOUNT.dkr.ecr.$REGION.amazonaws.com\":{\"username\":\"AWS\",\"password\":\"$(aws ecr get-login-password --region $REGION)\",\"email\":\"$EMAIL\"}}}" | base64 -w 0)
type: kubernetes.io/dockerconfigjson
EOF

# CRON_JOB="0 */12 * * * ./aws-ecr-secret.sh"
# (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
