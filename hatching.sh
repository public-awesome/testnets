#!/bin/bash

NETWORK=bellatrix-1
CONFIG=~/.starsd/config
INITIAL_COINS=100000000ustarx

rm -rf $CONFIG/gentx && mkdir $CONFIG/gentx
starsd init stargaze --chain-id=$NETWORK --stake-denom ustarx --overwrite
for i in $NETWORK/gentx/*.json; do
  echo $i
  starsd add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) $INITIAL_COINS
  cp $i $CONFIG/gentx/
done
starsd collect-gentxs

cp $CONFIG/genesis.json $NETWORK
