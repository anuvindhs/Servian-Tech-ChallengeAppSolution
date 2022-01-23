#!/bin/bash

progress-bar() {
  local duration=${1}


    already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇"; done }
    remaining() { for ((remain=$elapsed; remain<$duration; remain++)); do printf " "; done }
    percentage() { printf "| %s%%" $(( (($elapsed)*100)/($duration)*100/100 )); }
    clean_line() { printf "\r"; }

  for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
      already_done; remaining; percentage
      sleep 1
      clean_line
  done
  clean_line
}


echo "#########################################
* Script Partially complete

- ACM Certificate request
- ACM Validation 
- update CNAME to R53 

###########################################"

echo "Enter the domain name you want to create a certificate for: "
read domain



ACM_CERTIFICATE_ARN=$(aws acm request-certificate \
    --domain-name "$domain" \
    --subject-alternative-names "*.$domain" \
    --validation-method DNS \
    --query CertificateArn \
    --output text \
    --tags Key=Name,Value=ACM-app-test.erl.nz)

echo "[ACM]          Certificate ARN: $ACM_CERTIFICATE_ARN"



echo "[ACM]          Waiting for certificate to be ready..." 
progress-bar 10


VALIDATION_NAME="$(aws acm describe-certificate \
--certificate-arn "$ACM_CERTIFICATE_ARN" \
--query "Certificate.DomainValidationOptions[?DomainName=='$domain'].ResourceRecord.Name" \
--output text)"
 
VALIDATION_VALUE="$(aws acm describe-certificate \
--certificate-arn "$ACM_CERTIFICATE_ARN" \
--query "Certificate.DomainValidationOptions[?DomainName=='$domain'].ResourceRecord.Value" \
--output text)"

echo "[ACM]          Certificate validation record: $VALIDATION_NAME 
               CNAME: $VALIDATION_VALUE"
echo "[Route 53]      Creating Route53 record for $domain"
progress-bar 10

 R53_HOSTED_ZONE_ID="$(aws route53 list-hosted-zones-by-name \
--dns-name "$domain" \
--query "HostedZones[?Name=='$domain.'].Id" \
--output text)"
 
R53_HOSTED_ZONE=${R53_HOSTED_ZONE_ID##*/}
 
echo "[Route 53]     Hosted Zone ID: $R53_HOSTED_ZONE"
 

R53_CHANGE_BATCH=$(cat <<EOM
{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$VALIDATION_NAME",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$VALIDATION_VALUE"
          }
        ]
      }
    }
  ]
}
EOM
)

R53_CHANGE_BATCH_REQUEST_ID="$(aws route53 change-resource-record-sets \
--hosted-zone-id "$R53_HOSTED_ZONE" \
--change-batch "$R53_CHANGE_BATCH" \
--query "ChangeInfo.Id" \
--output text)"
echo "[Route 53]      Updated CNAME record for $domain"


