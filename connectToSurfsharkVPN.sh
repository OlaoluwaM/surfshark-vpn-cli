#!/usr/bin/env bash

locationArgument=$1
tcpOrUdpArgument=$2

location="${locationArgument:=us-atl}"
tcpOrUdp="${tcpOrUdpArgument:=tcp}"

. encpass.sh

username=$(get_secret surfshark username)
password=$(get_secret surfshark password)

expect <(cat << EOF
  spawn sudo openvpn $HOME/vpns/$location.prod.surfshark.com_$tcpOrUdp.ovpn
  expect "password for" {
      stty -echo
      interact -u tty_spawn_id -o "\r" return
      stty echo
    }
  expect "Username:"
  send "$username\r"
  expect "Password:"
  send "$password\r"
  interact
EOF
)
