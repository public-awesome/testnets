#!/bin/bash
set -eux

export STARGAZE_HOME=tmp/big-bang-1
export DENOM=ustars
export CHAIN_ID=big-bang-1

rm -rf $STARGAZE_HOME

starsd init moniker --chain-id big-bang-1 --home $STARGAZE_HOME
cp ./big-bang-1/pre-genesis.json $STARGAZE_HOME/config/genesis.json
wget https://s3.amazonaws.com/genesis.publicawesome.dev/snapshot.tar.gz -O snapshot.tar.gz
tar -xzvf snapshot.tar.gz
mkdir -p snapshots
mv snapshot.json snapshots/
wget https://s3.amazonaws.com/genesis.publicawesome.dev/devnet-snapshot.json  -O snapshots/devnet-snapshots.json
jq -s add snapshots/* > snapshot.json
rm snapshot.tar.gz
mkdir -p $STARGAZE_HOME/config/gentx

for i in $CHAIN_ID/gentx/*.json; do
    cp $i $STARGAZE_HOME/config/gentx/
done

# Prepare Genesis
starsd prepare-genesis testnet big-bang-1 snapshot.json --home $STARGAZE_HOME

starsd collect-gentxs --home $STARGAZE_HOME > /dev/null 2>&1

echo $?

starsd validate-genesis --home $STARGAZE_HOME
cp $STARGAZE_HOME/config/genesis.json big-bang-1/genesis/
cd  big-bang-1/genesis/
tar -czvf genesis.tar.gz genesis.json
rm genesis.json