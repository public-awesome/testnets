#/bin/sh
FILE=./check-gen-tx
DENOM=ustarx
CHAIN_ID=cygnusx-1
ONE_HOUR=3600
ONE_DAY=$(($ONE_HOUR * 24))
ONE_YEAR=$(($ONE_DAY * 365))
VALIDATOR_COINS=1000000000000$DENOM


if [ -f "$FILE" ]; then
    starsd init validator --chain-id cygnusx-1
    if [ "$1" == "mainnet" ]
    then
        LOCKUP=ONE_YEAR
    else
        LOCKUP=ONE_DAY
    fi
    echo "Lockup period is $LOCKUP"

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

    sed -i 's#tcp://127.0.0.1:26657#tcp://0.0.0.0:26657#g' ~/.starsd/config/config.toml
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
