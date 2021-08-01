#!/usr/bin/env bash

locationArgument=$1
tcpOrUdpArgument=$2

location="${locationArgument:=us-atl}"
tcpOrUdp="${tcpOrUdpArgument:=tcp}"

# To grab .env variables
set -o allexport
. "$(dirname $0)/.env"
set +o allexport

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
