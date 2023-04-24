#!/bin/bash
# Script to send message to matrix

#set -x

# Matrix homeserver URL
MATRIX_HOMESERVER=''

# MATRIX room ID
MATRIX_ROOM_ID=''

# MATRIX token
MATRIX_TOKEN=''

# Check if variable are set
check_var() {
	if [ "$MATRIX_HOMESERVER" == '' ]; then	
		error "MATRIX_HOMESERVER variable not set"
	fi 
	if [ "$MATRIX_ROOM_ID" == '' ]; then
		error "MATRIX_ROOM_ID variable not set"
	fi
}

# Check if token is set
check_token() {
	if [ "$MATRIX_TOKEN" == '' ]; then
		error "MATRIX_TOKEN variable empty, use $0 -t <username> <password>"
	fi 
}

# Display an error and leave
error() {
	echo -e "\033[0;31m$@\033[0m"
	exit 1
}

# Clean an input
clean() {
	local input=$@
	printf '%s' "$input" | jq -Rs '.'
}

# Make a request, $1 the CURL request
request() {
	local request=$@
	local errorcode="$(jq -r '.errcode' <<< "$request")"

	if [[ "$errorcode" != "" && "$errorcode" != "null" ]]; then
		error "[x] Erreur: "$(jq -r '.error' <<< "$request")""
	fi
}

# Get the token of the account
# usage: ./matrix.sh -t <username> <password>
# get_token <username> <password>
get_token() {
	check_var
	local token=$(curl -XPOST -H "Content-Type: application/json" --data "{\"type\": \"m.login.password\", \"identifier\": {\"user\": \"$1\", \"type\": \"m.id.user\"}, \"password\": \"$2\"}" \
		"https://${MATRIX_HOMESERVER#https://}/_matrix/client/r0/login")
	request $token
	
	token=$(echo "$token" | jq -r '.access_token')
	sed -i -e "s#^MATRIX_TOKEN=.*#MATRIX_TOKEN=\'${token}\'#g" $0
	echo -e "\033[1;32m[V] Token succesfully added\033[0m"
}

# Send a message
# usage: ./matrix.sh -s <message>
# usage: ./matrix.sh -html <message>
# send_message <message>
send_message() {
	check_var
	check_token
	local id=$(date +%s%N) # Message id
	local message=$(clean "$@")

	if $HTML; then
		local data="{\"msgtype\": \"m.text\", \"body\": $message, \"format\": \"org.matrix.custom.html\", \"formatted_body\": $message}"
	else
		local data="{\"body\": $message, \"msgtype\": \"m.text\"}" 
	fi
	request $(curl -XPUT -H "Authorization: Bearer ${MATRIX_TOKEN}" -H "Content-Type: application/json" --data "$data" \
		"https://${MATRIX_HOMESERVER#https://}/_matrix/client/r0/rooms/$MATRIX_ROOM_ID/send/m.room.message/$id")
	echo -e "\033[1;32m[v] Message sent\033[0m"
}

# Show the help menu
help() {
	echo "Usage: $0 <actions> <options>"
	echo ""
	echo "Actions:"
	echo "  -h, --help show this menu"
	echo "  -t <username> <password> get the token of the account and save it"
	echo "  -s <message> send a message"
	echo "  -html <html> send an html message"
}

# Main
hash curl >/dev/null 2>&1 || error "Curl is required!"
hash jq >/dev/null 2>&1 || error "jq is required!"

action=""
case $1 in
-t)
	get_token $2 $3
	exit 0
	;;

-s)
	action="send"
	shift
	;;

-html)
	action="html"
	shift
	;;

-h|--help|*)
	help
	exit 0
	;;
esac

MESSAGE=$@
case $action in
send)
	send_message "$MESSAGE"
	;;
html)
	HTML="true"
	send_message "$MESSAGE"
	;;
esac
