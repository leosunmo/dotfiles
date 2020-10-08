#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset


VPN_ID="${1:?"please provide VPN ID"}"
for VPN_ID; do
  if ! nmcli con up id ${VPN_ID} &>/dev/null
  then
      nmcli con down id ${VPN_ID} &>/dev/null
  fi
done
