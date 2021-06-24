#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ ! -s `echo ${SCRIPT_DIR}/key.txt` ]; then
	echo "Key file is empty or does not exist"
	exit 1
fi

if [ ! -s `echo ${SCRIPT_DIR}/zone.txt` ]; then
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

if [ -z $CERTBOT_AUTH_OUTPUT ]; then
	echo "No auth output. Are you running this script through certbot? (An example command is included in command.txt)"
	exit 1
fi

TW_ZONE=`cat ${SCRIPT_DIR}/zone.txt`
TW_KEY=`cat ${SCRIPT_DIR}/key.txt`
TW_CERTBOT_RECORD_ID=`echo $CERTBOT_AUTH_OUTPUT | jq .domain_record.id`

curl -s -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $TW_KEY" "https://api.digitalocean.com/v2/domains/$TW_ZONE/records/$TW_CERTBOT_RECORD_ID"
