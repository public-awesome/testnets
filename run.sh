#/bin/sh
FILE=./check-gen-tx
if [ -f "$FILE" ]; then
    starsd start &
    sleep 30
fi
