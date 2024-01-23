#!/bin/sh

INTERFACE=eno1
B_NAME=virbr-01

GATEWAY=192.168.2.1
# Your ip + mask
NETWORK=192.168.2.147/24

if [[ "$1" == '-A' ]]; then
  ip link add name $B_NAME type bridge
  ip link set dev $B_NAME up

  ip address add $NETWORK dev $B_NAME
  ip route append default via $GATEWAY dev $B_NAME

  ip link set $INTERFACE up
  ip link set $INTERFACE master $B_NAME
elif [[ "$1" == '-D' ]]; then
  ip link set $INTERFACE nomaster

  ip link set dev $B_NAME down
  ip link delete $B_NAME type bridge

  ip address replace $NETWORK dev $INTERFACE
  ip route replace default via $GATEWAY dev $INTERFACE
fi