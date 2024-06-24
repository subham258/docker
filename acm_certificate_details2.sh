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
app="$2"
environment="$3"

# Validate if region is provided
#if [ -z "$region" ]; then
#    echo "Region argument is missing or empty."
#    exit 1
#fi

# AWS CLI command to list ACM certificates based on tags
#certificate_arns=$(aws acm list-certificates --query 'CertificateSummaryList[].CertificateArn' --region $region --output text)
aws acm list-certificates --output text \
  | awk '{print $1, $4, $5}' \
  | column -t

echo "Listed all your AWS ACM certificates."

exit 0




