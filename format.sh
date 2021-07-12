#!/bin/bash

NETWORK=cygnusx-1

for i in $NETWORK/gentx/*.json; do
  echo $i
  cat $i | jq '.' > /tmp/gentx.json
  cp /tmp/gentx.json $i
  rm /tmp/gentx.json
done
