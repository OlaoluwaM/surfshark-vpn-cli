#!/usr/bin/env bash

#NOTE: WIP
# TODO: Tidy up script

# Check if OpenVpn package is installed
if ! command -v openvpn &>/dev/null; then
  echo "OpenVPN is not installed, installing..."
  sudo dnf install openvpn
else
  echo "OpenVPN is installed :eyes:"
fi

myarray=($(find /etc/openvpn -maxdepth 1 -name "*.ovpn"))

if [ ${#myarray[@]} -eq 0 ]; then
  echo "Installing configuration files..."
  sudo wget https://my.surfshark.com/vpn/api/v1/server/configurations -P /etc/openvpn
  sudo unzip /etc/openvpn/configurations
  sudo rm /etc/openvpn/configurations
  [ ${#myarray[@]} -gt 200 ] && echo "Servers added"
fi

source "$(dirname $0)/connectToSurfsharkVPN.sh"
