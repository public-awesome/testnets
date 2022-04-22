generate:
	rm -rf tmp/stargaze
	starsd init node --chain-id double-double-1 --home tmp/stargaze --overwrite
	go run main.go
	jq '.genesis_time="2022-02-17T17:00:00Z"' tmp/stargaze/config/genesis.json > double-double-1/pre-genesis.json

build:
	sh double-double-1/build.sh
