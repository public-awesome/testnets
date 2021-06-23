#!/bin/bash

CONFIG=~/.starsd/config
NETWORK=cygnusx-1

echo "Writing genesis accounts..."
sh ./accounts.sh

echo "Writing validator transactions..."
sh ./validators.sh

echo "Process default genesis changes.."
sed -i '' 's/"default_send_enabled": true/"default_send_enabled": false/g' $NETWORK/genesis.json

cp $CONFIG/genesis.json $NETWORK
