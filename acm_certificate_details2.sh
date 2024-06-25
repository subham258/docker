#! /bin/bash
set -e

ACM_REGION=$1
APP=$2
ENVIRONMENT=$3

aws acm list-certificates --region $ACM_REGION --query 'CertificateSummaryList[].{Arn:CertificateArn, DomainName:DomainName, SubjectAlternativeNames:SubjectAlternativeNames[].Name, Status:Status}' --output text



