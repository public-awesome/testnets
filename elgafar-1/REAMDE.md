# Stargaze Elgafar Tesnet Instructions

## Minimum hardware requirements

- 16GB RAM
- 200GB of disk space

## Software requirements

Stargaze has releases for Linux [here](https://github.com/public-awesome/stargaze/releases/tag/v6.0.0).

- [Ubuntu Setup Guide](./ubuntu.md)
- Latest version : [v6.0.0](https://github.com/public-awesome/stargaze/releases/tag/v6.0.0)

### Install Stargaze

Requires [Go version v1.18+](https://golang.org/doc/install).

```sh
> git clone https://github.com/public-awesome/stargaze && cd stargaze
> git fetch origin --tags
> git checkout v6.0.0
> make install
```

#### Verify installation

To verify if the installation was successful, execute the following command:

```sh
> starsd version --long
```

It will display the version of starsd currently installed:

```sh
name: stargaze
server_name: starsd
version: 6.0.0
commit: b8294bc957300b07ed40981b1bd08adc548020b3
build_tags: netgo,ledger
go: go version go1.18 linux/amd64
```

## Create testnet validator

1. Init Chain and start your node

   ```sh
   > starsd init <moniker-name> --chain-id=elgafar-1
   ```

2. Create a local key pair

   ```sh
   > starsd keys add <key-name>
   > starsd keys show <key-name> -a
   ```

3. Download genesis
   Fetch `genesis.json` into `starsd`'s `config` directory.

   ```sh
   > curl -s https://raw.githubusercontent.com/public-awesome/testnets/main/elgafar-1/genesis/genesis.tar.gz > genesis.tar.gz
   > tar -C ~/.starsd/config/ -xvf genesis.tar.gz
   ```

   **Genesis sha256**

   ```sh
    shasum -a 256 ~/.starsd/config/genesis.json
    3b6b974f3b882b0ff94366169c4e598810ba4774f389c2816d9acb2fb71200b4  /home/<user>/.starsd/config/genesis.json
   ```

4. Start your node and sync to the latest block

5. Create validator

   ```sh
   $ starsd tx staking create-validator \
   --amount 50000000ustars \
   --commission-max-change-rate "0.1" \
   --commission-max-rate "0.20" \
   --commission-rate "0.1" \
   --min-self-delegation "1" \
   --details "validators write bios too" \
   --pubkey=$(starsd tendermint show-validator) \
   --moniker <your_moniker> \
   --chain-id elgafar-1 \
   --gas-prices 0.025ustars \
   --from <key-name>
   ```

6. Request tokens from the [Stargaze Discord #faucet channel](https://discord.gg/stargaze) if you need more.

## Peers

```
e31886cba90a06e165b0df18cc5c8ae015ecd23e@209.159.152.82:26656,de00d2d65594b672469ecd65826a94ec1be80b9f@208.73.205.226:26656
```

## Endpoints

- https://rpc.elgarfar-1.stargaze-apis.com
- https://rest.elgarfar-1.stargaze-apis.com
