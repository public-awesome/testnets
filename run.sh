#/bin/sh
FILE=./check-gen-tx
DENOM=ustarx
CHAIN_ID=cygnusx-1
if [ -f "$FILE" ]; then
    echo "checking gentx collect"
    export FILE_LOCATION=$(cat check-gen-tx-file)
    starsd init validator --chain-id cygnusx-1
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
    starsd start &
    sleep 60
fi
