#!/bin/bash

CONFIG=~/.starsd/config
NETWORK=cygnusx-1

# echo "Writing genesis accounts..."
# sh ./accounts.sh

curl -O https://archive.interchain.io/4.0.2/genesis.json
starsd export-airdrop-snapshot uatom genesis.json snapshot.json


echo "Writing validator transactions..."
sh ./validators.sh

cp $CONFIG/genesis.json $NETWORK
