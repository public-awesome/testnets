#/bin/sh
FILE=./check-gen-tx
if [ -f "$FILE" ]; then
    echo "checking gentx collect"
    export ADDRESS=$(cat check-gen-tx)
    starsd add-genesis-account $ADDRESS 1000000000000000ustarx
    starsd collect-gentxs
fi
