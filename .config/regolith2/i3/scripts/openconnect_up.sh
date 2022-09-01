#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

VPN_NAME="${1:?"please provide VPN ID"}"
for VPN_NAME; do
  if ! nmcli -f GENERAL.STATE con show "${VPN_NAME}" &>/dev/null; then
    QTWEBENGINE_DISABLE_SANDBOX=1 OPENSSL_CONF=./openconnect-ssl.conf openconnect-sso
  fi
done
