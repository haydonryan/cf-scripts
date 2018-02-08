#!/bin/bash
#
# Thanks to Kurt Kellner for this script.
# 
# 1. Log into the opsman UAA server
# 2. Get the ERT UAA server login credentials
# 3. Log into the ERT UAA server with the retrieved credentials

opsman_username=$1
opsman_password=$2
opsman_dns=$3
uaa_common_dir=$(dirname $0)
script_name=$(basename $0)
set -eu
echo "${script_name}: 1. Logging into the opsman UAA server at
${opsman_dns} as ${opsman_username}"
${uaa_common_dir}/uaa_login.sh ${opsman_dns} ${opsman_username}
${opsman_password}
echo "${script_name}: 2. Getting the ERT UAA server login credentials"
cf_identifier=$(${uaa_common_dir}/uaa_curl.sh -s
"https://${opsman_dns}/api/v0/deployed/products/" | jq -r '.[] |
select(.type == "cf") | .guid')
uaa_ert_admin_client_password=$(${uaa_common_dir}/uaa_curl.sh -s
"https://${opsman_dns}/api/v0/deployed/products/${cf_identifier}/credent
ials/.uaa.admin_client_credentials" | jq -r
'.credential.value.password')
echo "${script_name}: 3. Getting the ERT system domain"
system_domain=$(${uaa_common_dir}/uaa_curl.sh -s
"https://${opsman_dns}/api/v0/staged/products/${cf_identifier}/propertie
s/" | jq -r '.properties.".cloud_controller.system_domain".value')
echo "${script_name}: 4. Logging into the ERT UAA server at
${system_domain} with the retrieved credentials"
uaac target uaa.${system_domain} --skip-ssl-validation
uaac token client get admin -s ${uaa_ert_admin_client_password}
