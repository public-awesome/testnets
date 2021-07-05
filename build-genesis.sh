#!/bin/bash

# CONFIG=~/.starsd/config
# NETWORK=cygnusx-1

# echo "Writing genesis accounts..."
# sh ./accounts.sh

rm -rf ~/.starsd

curl -O https://archive.interchain.io/4.0.2/genesis.json
starsd export-airdrop-snapshot uatom genesis.json snapshot.json

starsd import-genesis-accounts-from-snapshot snapshot.json

starsd prepare-genesis testnet cygnusx-1

# echo "Writing validator transactions..."
# sh ./validators.sh

# cp $CONFIG/genesis.json $NETWORK
