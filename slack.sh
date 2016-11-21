#!/bin/bash

# file: /etc/fail2ban/action.d/slack.sh

# message first command argument
MESSAGE=$1

HOOK_URL=https://hooks.slack.com/services/<your hook url>
HOST=$(hostname)
CHANNEL="#notifications"
USERNAME="fail2ban"
ICON=":fail2ban:"

# ip second command argument
if [ "$#" -ge 2 ]; then
	IP=$2
	# lets find out from what country we have our hacker
	COUNTRY=$(curl ipinfo.io/${IP}/country)
	# converting country to lover case
	COUNTRY=$(echo "$COUNTRY" | tr -s  '[:upper:]'  '[:lower:]')
	# slack emoji
	COUNTRY=":flag-$COUNTRY:"

	# replace _country_ template to the country emoji
	MESSAGE="${MESSAGE/_country_/$COUNTRY}"
fi

curl -X POST --data-urlencode "payload={\"channel\": \"${CHANNEL}\", \"username\": \"${USERNAME}\", \"text\": \"[*${HOST}*] ${MESSAGE}\", \"icon_emoji\": \"${ICON}\", \"mrkdwn\": true}" ${HOOK_URL}

exit 0
