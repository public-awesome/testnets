# Stargaze Cygnus X-1 Testnet Instructions

## Minimum hardware requirements

- 2x CPUs
- 4GB RAM
- 50GB+ of disk space

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
```

#### Verify installation

To verify if the installation was successful, execute the following command:

```sh
> starsd version --long
```

It will display the version of `starsd` currently installed:

```sh
name: stargaze
server_name: starsd
version: 0.6.0
commit: 3f7bed1cd9384eeca878277e4dcb92d1aa3aea1b
build_tags: netgo,faucet
go: go version go1.15.8 linux/amd64
```

## Setup validator node

Below are the instructions to generate and submit your genesis transaction.

### Generate genesis transaction (gentx)

1. Initialize the Stargaze directories and create the local genesis file with the correct
   chain-id

   ```sh
   > starsd init <moniker-name> --chain-id=cygnusx-1
   ```

2. Create a local key pair

   ```sh
   > starsd keys add <key-name>
   ```

3. Add your account to your local genesis file with a given amount and the key you
   just created. Use only `1000000000000ustarx`, other amounts will be ignored.

   ```sh
   > starsd add-genesis-account $(starsd keys show <key-name> -a) 1000000000000ustarx
   ```

4. Create the gentx

   ```sh
   > starsd gentx <key-name> 500000000000ustarx --chain-id=cygnusx-1
   ```

   If all goes well, you will see a message similar to the following:

   ```sh
   Genesis transaction written to "/home/user/.starsd/config/gentx/gentx-******.json"
   ```

### Submit genesis transaction

Submit your gentx in a PR [here](https://github.com/public-awesome/networks)

- Fork [the networks repo](https://github.com/public-awesome/networks) into your Github account

- Clone your repo using

  ```sh
  > git clone https://github.com/<your-github-username>/networks
  ```

- Copy the generated gentx json file to `<repo_path>/cygnusx-1/gentx/`

  ```sh
  > cd testnets
  > cp ~/.starsd/config/gentx/gentx*.json ./cygnusx-1/gentx/
  ```

- Commit and push to your repo
- Create a PR onto https://github.com/public-awesome/networks

#### Genesis & seeds

Fetch `genesis.json` into `starsd`'s `config` directory.

```sh
> curl https://raw.githubusercontent.com/public-awesome/networks/master/cygnusx-1/genesis.json > $HOME/.starsd/config/genesis.json
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
# [TBD] Comma separated list of seed nodes to connect to
seeds = ""
```

```sh
# Comma separated list of persistent peers to connect to
persistent_peers = ""
```

#### Set validator gas fees

You can set the minimum gas prices for transactions to be accepted into your node's mempool. This sets a lower bound on gas prices, preventing spam. Stargaze will launch accepting 0 gas fees to bootstrap the network.

```sh
> vi $HOME/.starsd/config/app.toml
```

```sh
minimum-gas-prices = ""
```

#### Start node automatically (Linux only)

Create a `systemd` service

```sh
> sudo vi /etc/systemd/system/starsd.service
```

Copy and paste the following and update `<user>` and `<GO_PATH>`:

```sh
[Unit]
Description=starsd
After=network-online.target

[Service]
User=<user>
ExecStart=<GO_PATH>/bin/starsd start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

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
