#!/bin/bash
CHAIN_ID=cygnusx-1
for i in $CHAIN_ID/gentx/*.json; do
    pubkeybase64=$(jq -r '.body.messages[0].pubkey.key' $i)
    pubkey=$(starsd debug pubkey $pubkeybase64 | grep Consensus | rev | cut -d " " -f1 | rev)
    local_pub_key=$(starsd tendermint show-validator)
    echo "Checking file $i"
    if [ "$pubkey" == "$local_pub_key" ]; then
        echo "This is a validator node"
        echo "Your gentx is $i"
        exit 0;
    fi
done
echo "This is not a validator node"
exit 1;
