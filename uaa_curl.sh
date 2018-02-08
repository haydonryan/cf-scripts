#!/bin/bash
# Used with permission from Kurt Kellner
# uaac_curl script
#
# Example usage:
# ./uaac_curl.sh -s
"https://172.28.31.5/api/v0/deployed/director/credentials/director_credentials"
#
token="$(uaac context | awk '/^ *access_token\: *([a-zA-Z0-9.\/+\-_]+)*$/ {print $2}' -)"
curl -k -H"Authorization: bearer $token" "$@"
