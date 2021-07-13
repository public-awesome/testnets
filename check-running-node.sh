#/bin/sh
FILE=./check-gen-tx
if [ -f "$FILE" ]; then
    sleep 50
    curl http://runner:26657/status
fi
