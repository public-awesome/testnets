#!/bin/bash

DENOM=ustarx
CHAIN_ID=cygnusx-1
ONE_HOUR=3600
ONE_DAY=$(($ONE_HOUR * 24))
ONE_YEAR=$(($ONE_DAY * 365))

if [ "$1" == "mainnet" ]
then
    LOCKUP=ONE_YEAR
else
    LOCKUP=ONE_DAY
fi
echo "Lockup period is $LOCKUP"

rm -rf ~/.starsd

if ! [ -f genesis.json ]; then
    curl -O https://archive.interchain.io/4.0.2/genesis.json
fi
starsd export-airdrop-snapshot uatom genesis.json snapshot.json

starsd init testmoniker --stake-denom $DENOM --chain-id $CHAIN_ID

starsd import-genesis-accounts-from-snapshot snapshot.json

# FIXME: THIS REMOVES ALL BALANCES
starsd prepare-genesis testnet $CHAIN_ID

# # add vesting accounts
# GENESIS_TIME=$(jq '.genesis_time' ~/.starsd/config/genesis.json | tr -d '"')
# echo "Genesis time is $GENESIS_TIME"
# GENESIS_UNIX_TIME=$(TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" ${GENESIS_TIME:0:19} +%s)
# vesting_start_time=$(($GENESIS_UNIX_TIME + $LOCKUP))
# vesting_end_time=$(($vesting_start_time + $LOCKUP))

# starsd add-genesis-account stars1s4ckh9405q0a3jhkwx9wkf9hsjh66nmuu53dwe 333333333333333ustarx \
#     --vesting-amount 333333332333333ustarx \
#     --vesting-start-time $vesting_start_time \
#     --vesting-end-time $vesting_end_time

# starsd validate-genesis

# echo "Writing validator transactions..."
# sh ./validators.sh

# cp ./starsd/config/genesis.json $CHAIN_ID
