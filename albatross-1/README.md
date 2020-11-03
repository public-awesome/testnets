# Stakebird Albatross Testnet Instructions

## Minimum hardware requirements

- 1GB RAM
- 25GB of disk space
- 1.4 GHz CPU

## Software requirements

Stakebird has releases for Linux and MacOS [here](https://github.com/public-awesome/stakebird/releases/tag/v0.3.2).

- [Ubuntu Setup Guide](./ubuntu.md)
- Latest version : [v0.3.2](https://github.com/public-awesome/stakebird/releases/tag/v0.3.2)

### Install Stakebird

You can install Stakebird by downloading the binary (easiest), or compiling from source.

#### Option 1: Download binary

1. Download the binary for your platform: [releases](https://github.com/public-awesome/stakebird/releases/tag/v0.3.2).
2. Copy it to a location in your PATH, i.e: `/usr/local/bin` or `$HOME/bin`.

i.e:
```sh
> wget https://github.com/public-awesome/stakebird/releases/download/v0.3.2/stakebird_0.3.2_linux_arm64.tar.gz
> sudo tar -C /usr/local/bin -zxvf stakebird_0.3.2_linux_arm64.tar.gz
```

#### Option 2: Build from source

Requires [Go version v1.14+](https://golang.org/doc/install).

```sh
> mkdir -p $GOPATH/src/github.com/public-awesome
> cd $GOPATH/src/github.com/public-awesome
> git clone https://github.com/public-awesome/stakebird && cd stakebird
> git checkout v0.3.2
> FAUCET_ENABLED=true make install
```

#### Verify installation

To verify if the installation was successful, execute the following command:

```sh
> staked version --long
```

It will display the version of staked currently installed:

```sh
name: stakebird
server_name: staked
version: 0.3.2
commit: a152fc6aab2f3259d24e071f58855cf445236b55
build_tags: netgo,faucet
go: go version go1.15.3 linux/amd64
```

NOTE: Make sure `build_tags` includes "faucet", which is required for testnet.

## Setup validator node

If you are looking to join the testnet post genesis time (_Nov 03 2020 1600 UTC_), skip to [Create Testnet Validator](#create-testnet-validator)

Below are the instructions to generate & submit your genesis transaction

### Generate genesis transaction (gentx)

1. Initialize the Stakebird directories and create the local genesis file with the correct
   chain-id

   ```sh
   > staked init <moniker-name> --chain-id=albatross-1
   ```

2. Create a local key pair

   ```sh
   > staked keys add <key-name>
   ```

3. Add your account to your local genesis file with a given amount and the key you
   just created. Use only `1000000000uegg`, other amounts will be ignored. EGG is testnet STB.

   ```sh
   > staked add-genesis-account $(staked keys show <key-name> -a) 1000000000uegg
   ```

4. Create the gentx

   ```sh
   > staked gentx <key-name> --amount=900000000uegg --chain-id=albatross-1
   ```

   If all goes well, you will see a message similar to the following:

    ```sh
    Genesis transaction written to "/home/user/.staked/config/gentx/gentx-******.json"
    ```

### Submit genesis transaction

> NOTE: To prevent malicious validators, and to ensure a fair and decentralized launch, the following rules will be enforced:
> 1. Github accounts must be at least a year old
> 2. Only one gentx per Github account is allowed

Submit your gentx in a PR [here](https://github.com/public-awesome/stakebird-testnets)

- Fork [the testnets repo](https://github.com/public-awesome/stakebird-testnets) into your Github account

- Clone your repo using

    ```sh
    > git clone https://github.com/<your-github-username>/stakebird-testnets
    ```

- Copy the generated gentx json file to `<repo_path>/albatross-1/gentx/`

    ```sh
    > cd stakebird-testnets
    > cp ~/.staked/config/gentx/gentx*.json ./albatross-1/gentx/
    ```

- Commit and push to your repo
- Create a PR onto https://github.com/public-awesome/stakebird-testnets

### Start your validator node

Once after the genesis is released (_Nov 01 2020 1600 UTC_), follow the instructions below to start your validator node.

#### Genesis & seeds

Fetch `genesis.json` into `staked`'s `config` directory.

```sh
> curl https://raw.githubusercontent.com/public-awesome/stakebird-testnets/master/albatross-1/genesis.json > $HOME/.staked/config/genesis.json
```

Verify you have the correct genesis file:

```sh
> shasum -a 256 ~/.staked/config/genesis.json
fb13172f39d0e888601b828aea104e830aa64c3893ff478194e4d41b2e61f793  genesis.json
```

Add seed nodes in `config.toml`.

```sh
> vi $HOME/.staked/config/config.toml
```

Find the following section and add the seed nodes.

```sh
# Comma separated list of seed nodes to connect to
seeds = ""
```

```sh
# Comma separated list of persistent peers to connect to
persistent_peers = "a81c314a4619f85cccbb9bb69eeabd9d385bc82b@3.82.106.0:26656"
```

#### Set validator gas fees

You can set the minimum gas prices for transactions to be accepted into your node's mempool. This sets a lower bound on gas prices, preventing spam. Stakebird can accept gas in *any* currency. To accept both ATOM and EGG for example, set `minimum-gas-prices` in `app.toml`.

```sh
> vi $HOME/.staked/config/app.toml
```

```sh
minimum-gas-prices = "0.025uatom,0.025uegg"
```

#### Start node automatically (Linux only)

Create a `systemd` service

```sh
> sudo vi /lib/systemd/system/staked.service
```

Copy and paste the following and update `<your_username>` and `<go_workspace>`:

```sh
[Unit]
Description=staked
After=network-online.target

[Service]
User=<your_username>
ExecStart=/home/<your_username>/<go_workspace>/bin/staked start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

**This assumes `$HOME/go_workspace` to be your Go workspace. Your actual workspace directory may vary.**

```sh
> sudo systemctl enable staked
> sudo systemctl start staked
```

Check node status

```sh
> staked status
```

Check logs

```sh
> journalctl -u staked -f
```

## Create testnet validator

This section applies to those who are looking to join the testnet post genesis.

1. Init Chain and start your node

   ```sh
   > staked init <moniker-name> --chain-id=albatross-1 --stake-denom=uegg
   ```

   After that, please follow all the instructions from [Start your validator node](#start-your-validator-node)

2. Create a local key pair

   ```sh
   > staked keys add <key-name>
   > staked keys show <key-name> -a
   ```

3. Create validator

   ```sh
   $ staked tx staking create-validator \
   --amount 900000000uegg \
   --commission-max-change-rate "0.1" \
   --commission-max-rate "0.20" \
   --commission-rate "0.1" \
   --min-self-delegation "1" \
   --details "validators write bios too" \
   --pubkey=$(staked tendermint show-validator) \
   --moniker <your_moniker> \
   --chain-id albatross-1 \
   --from <key-name>
   ```

4. Request tokens from the [Stakebird Discord #validator channel](https://discord.gg/QeJWCrE) if you need more.
