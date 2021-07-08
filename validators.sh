#!/bin/bash

NETWORK=cygnusx-1
CONFIG=~/.starsd/config
INITIAL_COINS=500000000000ustarx

for i in $NETWORK/gentx/*.json; do
  echo $i
  starsd add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) $INITIAL_COINS
  cp $i $CONFIG/gentx/
done
starsd collect-gentxs
