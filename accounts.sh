#!/bin/bash

CONFIG=~/.starsd/config
NETWORK=cygnusx-1
GENESIS_TIME=2021-05-25T00:44:44.536813Z
START_TIME=$(TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" ${GENESIS_TIME:0:19} +%s)
ONE_HOUR=3600
ONE_DAY=$(($ONE_HOUR * 24))
ONE_YEAR=$(($ONE_DAY * 365.24))

rm -rf $CONFIG/gentx && mkdir $CONFIG/gentx
starsd init stargaze --chain-id=$NETWORK --stake-denom ustarx --overwrite

vesting_start_time=$(($START_TIME + $ONE_DAY))
vesting_end_time=$(($vesting_start_time + $ONE_DAY))

starsd add-genesis-account stars15zx6hhjcnnnwt3nlf49gae3dd5n4vkjxef6gq2 333333333333334ustarx \
    --vesting-amount 333333332333334ustarx \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time

starsd add-genesis-account stars1s4ckh9405q0a3jhkwx9wkf9hsjh66nmuu53dwe 333333333333333ustarx \
    --vesting-amount 333333332333333ustarx \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time

starsd add-genesis-account stars1g457jcltvqdpt50ysq8fe2e7hwtnmnlmc2mkht 333333333333333ustarx \
    --vesting-amount 333333332333333ustarx \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time

sed -i '' "2s/.*/  \"genesis_time\": \"$GENESIS_TIME\",/" $CONFIG/genesis.json
