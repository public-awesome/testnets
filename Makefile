generate:
	rm -rf tmp/stargaze
	starsd init node --chain-id big-bang-1 --home tmp/stargaze --overwrite
	go run main.go
	jq '.genesis_time="2022-02-17T17:00:00Z"' tmp/stargaze/config/genesis.json > big-bang-1/pre-genesis.json

build:
	sh big-bang-1/build.sh