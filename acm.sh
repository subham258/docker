#! /bin/bash

aws --version

# Function to print usage information
#!/bin/bash

function usage {
  echo "Usage: $0 -r REGION -t TAG -f FILE"
  echo "  -r REGION  (required) The AWS region where your certificates are located"
  echo "  -t TAG      (optional) Filter certificates by tag key (value is assumed to be 'present')"
  echo "  -f FILE     (required) The output file to store certificate information"
  exit 1
}

# Parse command-line arguments
while getopts ":r:t:f:" opt; do
  case $opt in
    r) REGION="$OPTARG" ;;
    t) TAG_KEY="$OPTARG" ;;
    f) OUTPUT_FILE="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage; ;;
  esac
done

# Check for required arguments
if [[ -z "$REGION" || -z "$OUTPUT_FILE" ]]; then
  echo "Missing required arguments. Please see usage." >&2
  usage
fi

# Build the AWS CLI command
COMMAND="aws acm list-certificates --region $REGION"

# Add filter by tag (if provided)
if [[ ! -z "$TAG_KEY" ]]; then
  COMMAND="$COMMAND --certificate-statuses ISSUED --filter \"Key=tag:$TAG_KEY,Value=*\""
fi

# Get certificate list (text format for easier parsing)
CERTIFICATES=$(aws $COMMAND --output text | awk '/  arn:/ {print $NF}')

# Check if there are any certificates
if [[ -z "$CERTIFICATES" ]]; then
  echo "No certificates found in AWS ACM."
  exit 0
fi

# Write header to output file
echo "List of AWS Certificates in region $REGION:" > "$OUTPUT_FILE"
echo "=========================" >> "$OUTPUT_FILE"

# Loop through each certificate and print details
for CERTIFICATE_ARN in $CERTIFICATES; do
  # Get certificate details
  CERTIFICATE_DETAILS=$(aws acm describe-certificate --certificate-arn $CERTIFICATE_ARN --region $REGION --output json)

  # Extract domain names from the certificate (assuming Subject Alternative Names)
  DOMAIN_NAMES=$(echo $CERTIFICATE_DETAILS | jq -r '.Certificate.SubjectAlternativeNames | .[]')

  # Extract status from the certificate
  STATUS=$(echo $CERTIFICATE_DETAILS | jq -r '.Certificate.Status')

  # Print certificate information to file
  echo "ARN: $CERTIFICATE_ARN" >> "$OUTPUT_FILE"
  echo "Domain Names: $DOMAIN_NAMES" >> "$OUTPUT_FILE"
  echo "Status: $STATUS" >> "$OUTPUT_FILE"
  echo "---------" >> "$OUTPUT_FILE"
done

echo "Certificate information written to: $OUTPUT_FILE"
