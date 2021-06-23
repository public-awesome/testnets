#!/bin/bash

CONFIG=~/.starsd/config
NETWORK=cygnusx-1

echo "Writing genesis accounts..."
sh ./accounts.sh

echo "Writing validator transactions..."
sh ./validators.sh

cp $CONFIG/genesis.json $NETWORK

echo "Process default genesis changes.."
sed -i '' 's/"default_send_enabled": true/"default_send_enabled": false/g' $NETWORK/genesis.json
sed -i '' 's/"unbonding_time": "1814400s",/"unbonding_time": "604800s",/g' $NETWORK/genesis.json
sed -i '' 's/"send_enabled": true,/"send_enabled": false,/g' $NETWORK/genesis.json
sed -i '' 's/"receive_enabled": true/"receive_enabled": false/g' $NETWORK/genesis.json
