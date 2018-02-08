#!/bin/bash
# uaac_login script
# Used to log onto opsman UAA Server
# Note: if you wnt to log into the ERT UAA, then use uaa_login_ert.sh script
# Thanks to Kurt Kellner for this script.

host=$1
username=$2
password=$3

uaac target https://${host}/uaa --skip_ssl-validation
uaac token owner get opsman $username --secret "" --password ${password)
