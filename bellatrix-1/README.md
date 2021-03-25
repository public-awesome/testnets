# Stargaze Bellatrix Testnet Instructions

## TLDR

Block explorer: [https://explorer.bellatrix-1.publicawesome.dev/](https://explorer.bellatrix-1.publicawesome.dev/)

Binaries: [v0.6.0](https://github.com/public-awesome/stargaze/releases/tag/v0.6.0)

Genesis file: [genesis.json](https://github.com/public-awesome/testnets/releases/download/bellatrix-1/genesis.json)

Seeds: `c36b75183e4047fb788dcc526e751439a6fda1f0@seed.bellatrix-1.publicawesome.dev:36656`

Peers: [peers](https://www.notion.so/Stargaze-Bellatrix-Testnet-Seeds-Peers-3f0cd9e7c76e49c0859778690f514d5c)

## Minimum hardware requirements

- 2GB RAM
- 25GB of disk space
- 1.4 GHz CPU

## Software requirements

Stargaze has releases for Linux [here](https://github.com/public-awesome/stargaze/releases/tag/v0.6.0).

- [Ubuntu Setup Guide](./ubuntu.md)
- Latest version : [v0.6.0](https://github.com/public-awesome/stargaze/releases/tag/v0.6.0)

### Install Stargaze

You can install Stargaze by downloading the binary (easiest), or compiling from source.

#### Option 1: Download binary

1. Download the binary for your platform: [releases](https://github.com/public-awesome/stargaze/releases/tag/v0.6.0).
2. Copy it to a location in your PATH, i.e: `/usr/local/bin` or `$HOME/bin`.

i.e:

```sh
# libwasmvm.so is needed by cgo bindings
> sudo wget https://github.com/CosmWasm/wasmvm/raw/v0.13.0/api/libwasmvm.so -O /lib/libwasmvm.so
> wget https://github.com/public-awesome/stargaze/releases/download/v0.6.0/stargaze_0.6.0_linux_amd64.tar.gz
> sudo tar -C /usr/local/bin -zxvf stargaze_0.6.0_linux_amd64.tar.gz
```

#### Option 2: Build from source

Requires [Go version v1.15+](https://golang.org/doc/install).

```sh
> mkdir -p $GOPATH/src/github.com/public-awesome
> cd $GOPATH/src/github.com/public-awesome
> git clone https://github.com/public-awesome/stargaze && cd stargaze
> git fetch origin --tags
> git checkout v0.6.0
> FAUCET_ENABLED=true make install
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
version: 0.6.0
commit: 3f7bed1cd9384eeca878277e4dcb92d1aa3aea1b
build_tags: netgo,faucet
go: go version go1.15.8 linux/amd64
```

NOTE: Make sure `build_tags` includes "faucet", which is required for testnet.

## Setup validator node

If you are looking to join the testnet post genesis time (_MAR 23 2021 1600 UTC_), skip to [Create Testnet Validator](#create-testnet-validator)

Below are the instructions to generate & submit your genesis transaction

### Generate genesis transaction (gentx)

1. Initialize the Stargaze directories and create the local genesis file with the correct
   chain-id

   ```sh
   > starsd init <moniker-name> --chain-id=bellatrix-1
   ```

2. Create a local key pair

   ```sh
   > starsd keys add <key-name>
   ```

3. Add your account to your local genesis file with a given amount and the key you
   just created. Use only `100000000ustarx`, other amounts will be ignored. STARX is testnet STAR.

   ```sh
   > starsd add-genesis-account $(starsd keys show <key-name> -a) 100000000ustarx
   ```

4. Create the gentx

   ```sh
   > starsd gentx <key-name> 90000000ustarx --chain-id=bellatrix-1
   ```

   If all goes well, you will see a message similar to the following:

   ```sh
   Genesis transaction written to "/home/user/.starsd/config/gentx/gentx-******.json"
   ```

### Submit genesis transaction

> NOTE: To prevent malicious validators, and to ensure a fair and decentralized launch, the following rules will be enforced:
>
> 1. Github accounts must be at least 6 months old and have history; accounts with little activity may not be accepted.
> 2. Only one gentx per Github account is allowed
> 3. We reserve the right to exercise our best judgement to protect the network against Sybil attacks. Preference will be given to validators with a proven track record of validating for other networks.

Submit your gentx in a PR [here](https://github.com/public-awesome/testnets)

- Fork [the testnets repo](https://github.com/public-awesome/testnets) into your Github account

- Clone your repo using

  ```sh
  > git clone https://github.com/<your-github-username>/testnets
  ```

- Copy the generated gentx json file to `<repo_path>/bellatrix-1/gentx/`

  ```sh
  > cd testnets
  > cp ~/.starsd/config/gentx/gentx*.json ./bellatrix-1/gentx/
  ```

- Commit and push to your repo
- Create a PR onto https://github.com/public-awesome/testnets

### Start your validator node

Once after the genesis is released (_MAR 22 2021 1600 UTC_), follow the instructions below to start your validator node.

#### Genesis & seeds

Fetch `genesis.json` into `starsd`'s `config` directory.

```sh
> curl https://raw.githubusercontent.com/public-awesome/testnets/master/bellatrix-1/genesis.json > $HOME/.starsd/config/genesis.json
```

Verify you have the correct genesis file:

```sh
> shasum -a 256 ~/.starsd/config/genesis.json
9f97fdbdcc358bb3cf2a32ddad51c7172a2c0fee0023f56cd69457c8500804cc  genesis.json
```

Add seed nodes in `config.toml`.

```sh
> vi $HOME/.starsd/config/config.toml
```

Find the following section and add the seed nodes.

```sh
# Comma separated list of seed nodes to connect to
seeds = "c36b75183e4047fb788dcc526e751439a6fda1f0@seed.bellatrix-1.publicawesome.dev:36656"
```

```sh
# Comma separated list of persistent peers to connect to
persistent_peers = ""
```

#### Set validator gas fees

You can set the minimum gas prices for transactions to be accepted into your node's mempool. This sets a lower bound on gas prices, preventing spam. Stargaze can accept gas in _any_ currency. To accept both ATOM and STARX for example, set `minimum-gas-prices` in `app.toml`.

```sh
> vi $HOME/.starsd/config/app.toml
```

```sh
minimum-gas-prices = "0.025ustarx"
```

#### Start node automatically (Linux only)

Create a `systemd` service

```sh
> sudo vi /etc/systemd/system/starsd.service
```

Copy and paste the following and update `<your_username>` and `<go_workspace>`:

```sh
[Unit]
Description=starsd
After=network-online.target

[Service]
User=<your_username>
ExecStart=/home/<your_username>/<go_workspace>/bin/starsd start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

**This assumes `$HOME/go_workspace` to be your Go workspace. Your actual workspace directory may vary.**

```sh
> sudo systemctl enable starsd
> sudo systemctl start starsd
```

Check node status

```sh
> starsd status
```

Check logs

```sh
> journalctl -u starsd -f
```

## Create testnet validator

This section applies to those who are looking to join the testnet post genesis.

1. Init Chain and start your node

   ```sh
   > starsd init <moniker-name> --chain-id=bellatrix-1 --stake-denom=ustarx
   ```

   After that, please follow all the instructions from [Start your validator node](#start-your-validator-node)

2. Create a local key pair

   ```sh
   > starsd keys add <key-name>
   > starsd keys show <key-name> -a
   ```

3. Create validator

   ```sh
   $ starsd tx staking create-validator \
   --amount 9000000000ustarx \
   --commission-max-change-rate "0.1" \
   --commission-max-rate "0.20" \
   --commission-rate "0.1" \
   --min-self-delegation "1" \
   --details "validators write bios too" \
   --pubkey=$(starsd tendermint show-validator) \
   --moniker <your_moniker> \
   --chain-id bellatrix-1 \
   --from <key-name>
   ```

4. Request tokens from the [Stargaze Discord #validator channel](https://discord.gg/QeJWCrE) if you need more.
