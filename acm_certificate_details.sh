#!/bin/bash

region=${1:-'ap-south-1'}  # Use provided region or default to 'ap-south-1'
tag_key=${2:-'Owner'}      # Tag key passed as a parameter, default to 'Owner'
tag_value=${3:-'infra'}    # Tag value passed as a parameter, default to 'infra'

# List all certificates
certificate_arns=$(aws acm list-certificates --query 'CertificateSummaryList[].CertificateArn' --region $region --output text)

# Initialize an empty array to hold filtered certificates
filtered_certificates=()

# Loop through each certificate ARN
for certificate_arn in $certificate_arns; do
    # Fetch the list of tags for the given certificate ARN
    tag_list=$(aws acm list-tags-for-certificate --certificate-arn $certificate_arn --region $region --query 'Tags[*]' --output json)

    # Check if the tag list contains the specified key-value pair
    match=$(echo $tag_list | jq -r ".[] | select(.Key==\"$tag_key\" and .Value==\"$tag_value\")")

    # If a match is found, add the certificate ARN to the filtered list
    if [ ! -z "$match" ]; then
        filtered_certificates+=($certificate_arn)
    fi
done

# Output the filtered certificates
for cert in "${filtered_certificates[@]}"; do
    echo $cert
done
