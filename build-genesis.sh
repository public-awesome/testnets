#!/bin/bash

DENOM=ustarx
CHAIN_ID=cygnusx-1
ONE_HOUR=3600
ONE_DAY=$(($ONE_HOUR * 24))
ONE_YEAR=$(($ONE_DAY * 365))
VALIDATOR_COINS=1000000000000ustarx

if [ "$1" == "mainnet" ]
then
    LOCKUP=ONE_YEAR
else
    LOCKUP=ONE_DAY
fi
echo "Lockup period is $LOCKUP"

rm -rf ~/.starsd

echo "Processing airdrop snapshot..."
if ! [ -f genesis.json ]; then
    curl -O https://archive.interchain.io/4.0.2/genesis.json
fi
starsd export-airdrop-snapshot uatom genesis.json snapshot.json
starsd init testmoniker --stake-denom $DENOM --chain-id $CHAIN_ID
starsd prepare-genesis testnet $CHAIN_ID
starsd import-genesis-accounts-from-snapshot snapshot.json

echo "Adding vesting accounts..."
GENESIS_TIME=$(jq '.genesis_time' ~/.starsd/config/genesis.json | tr -d '"')
echo "Genesis time is $GENESIS_TIME"
GENESIS_UNIX_TIME=$(TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" ${GENESIS_TIME:0:19} +%s)
vesting_start_time=$(($GENESIS_UNIX_TIME + $LOCKUP))
vesting_end_time=$(($vesting_start_time + $LOCKUP))

starsd add-genesis-account stars19vcu4svzydq79gqk504pg0fjn2nq4x03tvcz0p 100000000000000ustarx \
    --vesting-amount 100000000000000ustarx \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
starsd add-genesis-account stars12yxedm78tpptyhhasxrytyfyj7rg7dcqfgrdk4 16666666666667ustarx \
    --vesting-amount 16666666666667ustarx \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
starsd add-genesis-account stars1nek5njjd7uqn5zwf5zyl3xhejvd36er3qzp6x3 16666666666667ustarx \
    --vesting-amount 16666666666667ustarx \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
starsd add-genesis-account stars1avlcqcn4hsxrds2dgxmgrj244hu630kfl89vrt 16666666666667ustarx \
    --vesting-amount 16666666666667ustarx \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
starsd add-genesis-account stars1wppujuuqrv52atyg8uw3x779r8w72ehrr5a4yx 50000000000000ustarx \
    --vesting-amount 50000000000000ustarx \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time

echo "Processing validators..."
mkdir -p ~/.starsd/config/gentx
for i in $NETWORK/gentx/*.json; do
    echo $i
    starsd add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) $VALIDATOR_COINS \
        --vesting-amount $VALIDATOR_COINS \
        --vesting-start-time $vesting_start_time \
        --vesting-end-time $vesting_end_time
    cp $i ~/.starsd/config/gentx/
done
starsd collect-gentxs
starsd validate-genesis

cp ~/.starsd/config/genesis.json $CHAIN_ID
