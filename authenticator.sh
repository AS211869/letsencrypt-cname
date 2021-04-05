#!/bin/bash

if [ ! -s key.txt ]; then
	echo "Key file is empty or does not exist"
	exit 1
fi

if [ ! -s zone.txt ]; then
	echo "Zone file is empty or does not exist"
	exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "jq is not installed"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo "curl is not installed"
    exit 1
fi

TW_ZONE=`cat zone.txt`
TW_KEY=`cat key.txt`
TW_CERTBOT_DOMAIN=`echo $CERTBOT_DOMAIN | sed 's/\./-/g'`

curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TW_KEY" \
	-d '{"type":"TXT","name":"'"$TW_CERTBOT_DOMAIN"'","data":"'"$CERTBOT_VALIDATION"'","priority":null,"port":null,"ttl":100,"weight":null,"flags":null,"tag":null}' "https://api.digitalocean.com/v2/domains/$TW_ZONE/records"

sleep 30
