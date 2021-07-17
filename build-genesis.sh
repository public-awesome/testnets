#!/bin/bash
set -ex
DENOM=ustarx
CHAIN_ID=cygnusx-1
GENTXS=cygnusx-1
ONE_HOUR=3600
ONE_DAY=$(($ONE_HOUR * 24))
ONE_YEAR=$(($ONE_DAY * 365))
VALIDATOR_COINS=1000000000000$DENOM
REQUIRED_VERSION="0.10.0"
VERSION="$(starsd version |  awk '{print $NF}')"
if [ "$VERSION" != "$REQUIRED_VERSION" ]; then
    echo "starsd required $REQUIRED_VERSION, current $VERSION"
    exit 1
fi

if [ "$1" == "mainnet" ]
then
    LOCKUP=ONE_YEAR
else
    LOCKUP=ONE_DAY
fi
echo "Lockup period is $LOCKUP"

rm -f ~/.starsd/config/genesis.json
rm -f ~/.starsd/config/gentx/*

echo "Processing airdrop snapshot..."
if ! [ -f genesis.json ]; then
    curl -O https://archive.interchain.io/4.0.2/genesis.json
fi
starsd init testmoniker --chain-id $CHAIN_ID
starsd export-airdrop-snapshot uatom genesis.json snapshot.json
starsd prepare-genesis testnet $CHAIN_ID
starsd import-genesis-accounts-from-snapshot snapshot.json

echo "Adding vesting accounts..."
GENESIS_TIME=$(jq '.genesis_time' ~/.starsd/config/genesis.json | tr -d '"')
echo "Genesis time is $GENESIS_TIME"
if [[ "$OSTYPE" == "darwin"* ]]; then
    GENESIS_UNIX_TIME=$(TZ=UTC gdate "+%s" -d $GENESIS_TIME)
else
    GENESIS_UNIX_TIME=$(TZ=UTC date "+%s" -d $GENESIS_TIME)
fi
vesting_start_time=$(($GENESIS_UNIX_TIME + $LOCKUP))
vesting_end_time=$(($vesting_start_time + $LOCKUP))

starsd add-genesis-account stars1mxynx2ay7kxuu6vsu8ruy7pwgmsvz93atfj7nu 350000000000000$DENOM
starsd add-genesis-account stars13nh557xzyfdm6csyp0xslu939l753sdlgdc2q0 250000000000000$DENOM
starsd add-genesis-account stars1xuuv5vucu9h74svhma4ykfvjzu4j0rxrsn0yfk 16666666666667$DENOM \
    --vesting-amount 16666666666667$DENOM \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
starsd add-genesis-account stars1s4ckh9405q0a3jhkwx9wkf9hsjh66nmuu53dwe 16666666666667$DENOM \
    --vesting-amount 16666666666667$DENOM \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
starsd add-genesis-account stars1kdfmfxg4tq68jxvl95h99wq9mvz9lxg6whrsjh 16666666666667$DENOM \
    --vesting-amount 16666666666667$DENOM \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
starsd add-genesis-account stars1wppujuuqrv52atyg8uw3x779r8w72ehrr5a4yx 50000000000000$DENOM \
    --vesting-amount 50000000000000$DENOM \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time

echo "Processing validators..."
mkdir -p ~/.starsd/config/gentx
for i in $GENTXS/gentx/*.json; do
    echo $i
    starsd add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) $VALIDATOR_COINS \
        --vesting-amount $VALIDATOR_COINS \
        --vesting-start-time $vesting_start_time \
        --vesting-end-time $vesting_end_time
    cp $i ~/.starsd/config/gentx/
done
starsd collect-gentxs
starsd validate-genesis

cp ~/.starsd/config/genesis.json $GENTXS/pre-built.json
jq -S -f normalize.jq  ~/.starsd/config/genesis.json > $GENTXS/genesis.json
cp $GENTXS/genesis.json ~/.starsd/config/genesis.json
sha256sum $GENTXS/genesis.json
sha256sum ~/.starsd/config/genesis.json
