# Stargaze Double Double Testnet Instructions

## Minimum hardware requirements

- 16GB RAM
- 200GB of disk space

## Software requirements

Stargaze has releases for Linux [here](https://github.com/public-awesome/stargaze/releases/tag/v4.0.0).

- [Ubuntu Setup Guide](./ubuntu.md)
- Latest version : [v4.0.0](https://github.com/public-awesome/stargaze/releases/tag/v4.0.0)

### Install Stargaze

Requires [Go version v1.18+](https://golang.org/doc/install).

```sh
> git clone https://github.com/public-awesome/stargaze && cd stargaze
> git fetch origin --tags
> git checkout v4.0.0
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
version: 4.0.0
commit: 80cfeaa4c7123e87de162b9d8038eacb7d7cbff4
build_tags: netgo,ledger
go: go version go1.18 linux/amd64
```

## Create testnet validator

1. Init Chain and start your node

   ```sh
   > starsd init <moniker-name> --chain-id=double-double-1
   ```

2. Create a local key pair

   ```sh
   > starsd keys add <key-name>
   > starsd keys show <key-name> -a
   ```

3. Download genesis
   Fetch `genesis.json` into `starsd`'s `config` directory.

   ```sh
   > curl -s https://raw.githubusercontent.com/public-awesome/testnets/main/double-double-1/genesis/genesis.tar.gz > genesis.tar.gz
   > tar -C ~/.starsd/config/ -xvf genesis.tar.gz
   ```

   **Genesis sha256**

   ```sh
    shasum -a 256 ~/.starsd/config/genesis.json
    ea00bb804c30d8bd0e6b98f915c6e63dce4842193bce8410e854215980ed8166  /home/<user>/.starsd/config/genesis.json
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
   --chain-id double-double-1 \
   --gas-prices 0.025ustars \
   --from <key-name>
   ```

6. Request tokens from the [Stargaze Discord #faucet channel](https://discord.gg/stargaze) if you need more.

## Seed

```
69666f77b6a2355fcfc64c9879520a352b62917e@45.55.57.176:36658
```
