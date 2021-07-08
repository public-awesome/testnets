#!/bin/bash

CONFIG=~/.starsd/config
NETWORK=cygnusx-1

# echo "Writing genesis accounts..."
# sh ./accounts.sh

echo "Writing validator transactions..."
sh ./validators.sh

cp $CONFIG/genesis.json $NETWORK
