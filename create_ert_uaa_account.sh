#!/bin/bash
# Used with permission from Kurt Kellner
# 
# This will create a uaa client or user account in the ERT UAA server.
# In order to do this these steps are taken:
#
# 1. Call uaa_login_ert.sh or uaa_login_opsman.sh script to perform uaa
login
# 2. Create user/client account
#
# Required params:
create_username=$1
vault_key_for_password=$2   # Full path to vault key. e.g., concourse/main/my_password
scopes="$3"       # Comma delimited list of scopes to assign user (no spaces).  Example: cloud_controller.admin,scim.read,scim.write
create_type=$4    # Type of UAA account to create, either: client or user
opsman_username=$5
opsman_password=$6
opsman_dns=$7
uaa_common_dir=$(dirname $0)

set -eu
echo "Creating UAA ${create_type} Account ${create_username} with scopes: ${scopes}"

# Generate a password for the user/client we are about to create
password=$(openssl rand -base64 15)

if [ "${create_type}" == "user" ]; then
  echo "  2a. Checking if user account already exists"
  set +e
  uaac user get ${create_username} > /dev/null
  if [[ $? -eq 0 ]]; then
    echo "  User ${create_username} already exists.  Skipping create account."
exit 0 fi
set -e
  echo "  2b. Creating user account"
  uaac user add ${create_username} \
    --emails ${create_username} \
    --password ${password}
  # Assign scopes to newly created user
  IFS=","
  for scope in $scopes
  do
    echo "Assign scope: $scope"
    uaac member add $scope ${create_username}
  done
elif [ "${create_type}" == "client" ]; then
echo "  2a. Checking if client account already exists"
  set +e
  uaac client get ${create_username} > /dev/null
  if [[ $? -eq 0 ]]; then
    echo "  Client ${create_username} already exists. Skipping create account."
exit 0 fi
set -e
  echo "  2b. Creating client account"
  uaac client add ${create_username} \
    --name ${create_username} \
    --authorities ${scopes} \
    --secret ${password} \
    --authorized_grant_types client_credentials,refresh_token
else
  echo "ERROR: Unknown create type ${create_type}; must be user or
client"
  exit 1
fi
vault write ${vault_key_for_password} value=${password}
echo "Created ERT UAA ${create_type} Account ${create_username}.
Password stored in vault, location ${vault_key_for_password}"
