#! /bin/bash

#!/bin/bash

# Set AWS region
region="ap-south-1"  # Replace with your desired region

# Set variables for filtering ACM certificates
app="infra"  # Replace with the tag value you want to filter by
environment="DEV"  # Replace with the tag value you want to filter by

# AWS CLI command to list ACM certificates based on tags
certificate_list=$(aws acm list-certificates --region $region --query "CertificateSummaryList[?Tags[?Key=='Owner'&&Value=='$app'&&Key=='Environment'&&Value=='$environment']].CertificateArn" --output text)

echo "ACM Certificates for App: $app, Environment: $environment"
echo "$certificate_list"
