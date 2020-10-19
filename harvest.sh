#!/bin/bash

NETWORK=albatross-1
CONFIG=~/.staked/config

rm -rf $CONFIG/gentx && mkdir $CONFIG/gentx

for i in $NETWORK/gentx/*.json; do
  echo $i
  staked add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) $(jq -r '.body.messages[0].value.amount' $i)$(jq -r '.body.messages[0].value.denom' $i)
  cp $i $CONFIG/gentx/
done
staked collect-gentxs

cp $CONFIG/genesis.json $NETWORK
