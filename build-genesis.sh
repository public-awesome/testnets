#!/bin/bash

DENOM=ustarx
NETWORK=cygnusx-1

GENESIS_TIME=2021-05-25T00:44:44.536813Z
START_TIME=$(TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" ${GENESIS_TIME:0:19} +%s)
ONE_HOUR=3600
ONE_DAY=$(($ONE_HOUR * 24))
ONE_YEAR=$(($ONE_DAY * 365))
vesting_start_time=$(($START_TIME + $ONE_DAY))
vesting_end_time=$(($vesting_start_time + $ONE_DAY))

rm -rf ~/.starsd

if ! [ -f genesis.json ]; then
    curl -O https://archive.interchain.io/4.0.2/genesis.json
fi
starsd export-airdrop-snapshot uatom genesis.json snapshot.json

starsd init testmoniker --stake-denom $DENOM --chain-id $NETWORK

starsd import-genesis-accounts-from-snapshot snapshot.json

starsd prepare-genesis testnet $NETWORK

starsd add-genesis-account stars1s4ckh9405q0a3jhkwx9wkf9hsjh66nmuu53dwe 333333333333333ustarx \
    --vesting-amount 333333332333333ustarx \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time

starsd validate-genesis

# echo "Writing validator transactions..."
# sh ./validators.sh

# cp ./starsd/config/genesis.json $NETWORK
