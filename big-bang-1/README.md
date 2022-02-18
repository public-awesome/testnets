# Stargaze big-bang Testnet Instructions

## Minimum hardware requirements

- 16GB RAM
- 200GB of disk space

## Software requirements

Stargaze has releases for Linux [here](https://github.com/public-awesome/stargaze/releases/tag/v3.0.0-alpha).

- [Ubuntu Setup Guide](./ubuntu.md)
- Latest version : [v3.0.0-alpha](https://github.com/public-awesome/stargaze/releases/tag/v3.0.0-alpha)

### Install Stargaze

Requires [Go version v1.17+](https://golang.org/doc/install).

```sh
> git clone https://github.com/public-awesome/stargaze && cd stargaze
> git fetch origin --tags
> git checkout v3.0.0-alpha
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
version: 3.0.0-alpha.2
commit: ba8e715e3c60b44145d4380e3068e2d5a21e8535
build_tags: netgo,ledger
go: go version go1.17 linux/amd64
```

## Create testnet validator

1. Init Chain and start your node

   ```sh
   > starsd init <moniker-name> --chain-id=big-bang-1
   ```

2. Create a local key pair

   ```sh
   > starsd keys add <key-name>
   > starsd keys show <key-name> -a
   ```

3. Download genesis
   Fetch `genesis.json` into `starsd`'s `config` directory.

   ```sh
   > curl -s  https://raw.githubusercontent.com/public-awesome/testnets/main/big-bang-1/genesis/genesis.tar.gz > genesis.tar.gz
   > tar -C ~/.starsd/config/ -xvf genesis.tar.gz
   ```

   **Genesis sha256**

   ```sh
   jq -S -f normalize.jq  ~/.starsd/config/genesis.json | shasum -a 256

   193cd956fd14b7dc8bd3e07d18cebe6bfc2014b47d8a3228758ea4b26a83f8df  -
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
   --chain-id big-bang-1 \
   --gas-prices 0.025ustars \
   --from <key-name>
   ```

6. Request tokens from the [Stargaze Discord #faucet channel](https://discord.gg/stargaze) if you need more.
