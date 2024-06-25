#! /bin/bash

#!/bin/bash

# Set AWS region
#region="ap-south-1"  # Replace with your desired region

# Set variables for filtering ACM certificates
#app="infra"  # Replace with the tag value you want to filter by
#environment="DEV"  # Replace with the tag value you want to filter by

# AWS CLI command to list ACM certificates based on tags
#certificate_list=$(aws acm list-certificates --region $region --query "CertificateSummaryList[?Tags[?Key=='Owner'&&Value=='$app'&&Key=='Environment'&&Value=='$environment']].CertificateArn" --output text)

#echo "ACM Certificates for App: $app, Environment: $environment"
#echo "$certificate_list"



#!/bin/bash

# Usage: acm_certificate_details.sh <region> <app> <environment>

region="$1"
APP="$2"
ENVIRONMENT="$3"

# Validate if region is provided
#if [ -z "$region" ]; then
#    echo "Region argument is missing or empty."
#    exit 1
#fi

# AWS CLI command to list ACM certificates based on tags
#certificate_arns=$(aws acm list-certificates --query 'CertificateSummaryList[].CertificateArn' --region $region --output text)
#aws acm list-certificates --output text \
#  | awk '{print $1, $4, $5}' \
#  | column -t

#aws acm list-certificates --region $region --query CertificateSummaryList[].[CertificateArn,DomainName] --output text

aws acm list-certificates --region $region --query 'CertificateSummaryList[].CertificateArn' --output text
while IFS= read -r arn; do
  # Check if the certificate has a specific tag key and value (replace 'your-tag-key' and 'your-tag-value' accordingly)
  aws acm list-tags-for-certificate --certificate-arn "$arn" | grep --quiet 'ENVIRONMENT": "$ENVIRONMENT"'
  if [ $? -eq 0 ]; then
    # If the tag matches, describe the certificate to get details (optional)
    aws acm describe-certificate --certificate-arn "$arn"
  fi
done < <(aws acm list-certificates --query 'CertificateSummaryList[].CertificateArn' --output text)
echo "Listed all your AWS ACM certificates."

exit 0




