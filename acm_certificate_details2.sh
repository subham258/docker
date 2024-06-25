#! /bin/bash
set -e

ACM_REGION=$1
APP=$2
ENVIRONMENT=$3

set -x

# List all certificate ARNs
aws acm list-certificates --region ACM_REGION --query 'CertificateSummaryList[].CertificateArn' --output text | while IFS= read -r arn; do
  # Trim any leading or trailing whitespace from the ARN
  arn=$(echo "$arn" | tr -d '\r' | xargs)
  
  # Output the ARN for debugging
  echo "Processing ARN: '$arn'"

  # Fetch tags for each certificate
  tags=$(aws acm list-tags-for-certificate --certificate-arn "$arn")

  # Check if the certificate has the specific tags 'ENVIRONMENT': 'DEV' and 'Owner': 'infra'
  if echo "$tags" | grep --quiet '"Key": "ENVIRONMENT"' && echo "$tags" | grep --quiet '"Value": "ENVIRONMENT"' && echo "$tags" | grep --quiet '"Key": "Owner"' && echo "$tags" | grep --quiet '"Value": "APP"'; then
    # If the tags match, describe the certificate to get details
    aws acm describe-certificate --certificate-arn "$arn" --query 'Certificate.{CertificateArn:CertificateArn,DomainName:DomainName,Subject:Subject,Issuer:Issuer,CreatedAt:CreatedAt,Status:Status}' --output json
  fi
done




