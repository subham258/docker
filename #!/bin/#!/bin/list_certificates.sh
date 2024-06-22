#!/bin/bash

region=${1:-'ap-south-1'}  # Use provided region or default to 'ap-south-1'

# List all certificates
certificate_arns=$(aws acm list-certificates --query 'CertificateSummaryList[].CertificateArn' --region $region --output text)

# Output the certificate ARNs
for cert in $certificate_arns; do
    echo $cert
done
