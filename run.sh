#/bin/sh
FILE=./check-gen-tx
DENOM=ustarx
CHAIN_ID=cygnusx-1
if [ -f "$FILE" ]; then
    echo "checking gentx collect"
    export FILE_LOCATION=$(cat check-gen-tx-file)
    starsd init validator --chain-id cygnusx-1
    sed -i 's#tcp://127.0.0.1:26657#tcp://0.0.0.0:26657#g' ~/.gaiad/config/config.toml
    mkdir -p ~/.starsd/config/gentx
    echo "Processing validators..."
    for i in $CHAIN_ID/gentx/*.json; do
        echo $i
        starsd add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) $VALIDATOR_COINS \
            --vesting-amount $VALIDATOR_COINS \
            --vesting-start-time $vesting_start_time \
            --vesting-end-time $vesting_end_time
        cp $i ~/.starsd/config/gentx/
    done
    starsd collect-gentxs
    starsd validate-genesis
    starsd start
fi
