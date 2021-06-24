#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SLEEP=30

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

if [ -s `echo ${SCRIPT_DIR}/sleep.txt` ]; then
	SLEEP_TMP=`cat ${SCRIPT_DIR}/sleep.txt`
	re='^[0-9]+$'
	if [[ $SLEEP_TMP =~ $re ]] ; then
		SLEEP=$SLEEP_TMP
	fi
fi

if [ -z $CERTBOT_DOMAIN ]; then
	echo "No domain provided. Are you running this script through certbot? (An example command is included in command.txt)"
	exit 1
fi

TW_ZONE=`cat ${SCRIPT_DIR}/zone.txt`
TW_KEY=`cat ${SCRIPT_DIR}/key.txt`
TW_CERTBOT_DOMAIN=`echo $CERTBOT_DOMAIN | sed 's/\./-/g'`

curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TW_KEY" \
	-d '{"type":"TXT","name":"'"$TW_CERTBOT_DOMAIN"'","data":"'"$CERTBOT_VALIDATION"'","priority":null,"port":null,"ttl":100,"weight":null,"flags":null,"tag":null}' "https://api.digitalocean.com/v2/domains/$TW_ZONE/records"

sleep $SLEEP
