#!/usr/bin/env bash

read -e -t 10 -p 'Where would you like to connect to: ' -n 8 -i 'us-atl' locationArgument
echo
read -e -t 10 -p 'Would you like to use tcp or udp: ' -i 'tcp' tcpOrUdpArgument
echo

location="${locationArgument:=us-atl}"
tcpOrUdp="${tcpOrUdpArgument:=tcp}"
envFilePath="$(dirname $0)/.env"

# To grab .env variables
set -o allexport
. $envFilePath
set +o allexport

if [[ -z "$SURFSHARK_USERNAME" ]]; then
  read -t 20 -p 'Surfshark username not set in .env, please provide it: ' SURFSHARK_USERNAME
  [[ -z "$SURFSHARK_USERNAME" ]] && echo "Script cannot run without surfshark username" && exit 1

elif [[ -z "$SURFSHARK_PASSWORD" ]]; then
  read -t 20 -sp 'Surfshark password not set in .env, please provide it: ' SURFSHARK_PASSWORD
  [[ -z "$SURFSHARK_PASSWORD" ]] && echo "Script cannot run without surfshark password" && exit 1

fi

expect <(
  cat <<EOF
  spawn sudo openvpn $HOME/vpns/$location.prod.surfshark.com_$tcpOrUdp.ovpn
  expect "password for" {
      stty -echo
      interact -u tty_spawn_id -o "\r" return
      stty echo
    }
  expect "Username:"
  send "$SURFSHARK_USERNAME\r"
  expect "Password:"
  send "$SURFSHARK_PASSWORD\r"
  interact
EOF
) 2>/dev/null
