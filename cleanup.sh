#!/bin/bash

if [ ! -s key.txt ]; then
        echo "Key file is empty or does not exist";
        exit 1;
fi

TW_ZONE="acme.wntr.cc"
TW_KEY=`cat key.txt`
TW_CERTBOT_RECORD_ID=`echo $CERTBOT_AUTH_OUTPUT | jq .domain_record.id`

curl -s -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $TW_KEY" "https://api.digitalocean.com/v2/domains/$TW_ZONE/records/$TW_CERTBOT_RECORD_ID"
