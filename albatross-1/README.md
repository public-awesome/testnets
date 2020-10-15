# Albatross Testnet Instructions

## Software Requirements

- Go version v1.14.+
- Stakebird version : [v0.3.0](https://github.com/public-awesome/stakebird/releases/tag/v0.3.0)

### Install Stakebird

```sh
> mkdir -p $GOPATH/src/github.com/public-awesome
> cd $GOPATH/src/github.com/public-awesome
> git clone https://github.com/public-awesome/stakebird && cd stakebird
> git checkout v0.3.0
> make install
```

To verify if the installation was successful, execute the following command:

```sh
> staked version --long
```

It will display the version of staked currently installed:

```sh
name: Stakebird
server_name: staked
version: 0.3.0
commit: [TODO]
build_tags: netgo,ledger
go: go version go1.15.2 linux/amd64
```

## Setup validator node

If you are looking to join the testnet post genesis time (i.e, _21-Oct-2020 1600UTC_), skip to [Create Testnet Validator](#create-testnet-validator)

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
   just created. Use only `1000000000uegg`, other amounts will be ignored.

   ```sh
   > staked add-genesis-account $(staked keys show <key-name> -a) 1000000000uegg
   ```

4. Create the gentx

   ```she
   > staked gentx <key-name> --amount=900000000uegg --chain-id=albatross-1
   ```

   If all goes well, you will see a message similar to the following:

    ```sh
    Genesis transaction written to "/home/user/.staked/config/gentx/gentx-******.json"
    ```

### Submit genesis transaction

Submit your gentx in a PR [here](https://github.com/public-awesome/testnets)

- Fork the testnets repo into your Github account

- Clone your repo using

    ```sh
    > git clone https://github.com/<your-github-username>/testnets
    ```

- Copy the generated gentx json file to `<repo_path>/albatross-1/gentx/`

    ```sh
    > cd $GOPATH/src/github.com/public-awesome/testnets
    > cp ~/.staked/config/gentx/gentx*.json ./albatross-1/gentx/
    ```

- Commit and push to your repo
- Create a PR onto https://github.com/public-awesome/testnets

### Start your validator node

Once after the genesis is released (i.e., _20-Oct-2020 1600UTC_), follow the instructions below to start your validator node.

#### Genesis & Seeds

Fetch `genesis.json` into `staked`'s `config` directory.

```sh
> curl https://raw.githubusercontent.com/public-awesome/testnets/master/albatross-1/genesis.json > $HOME/.staked/config/genesis.json
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
persistent_peers = ""
```

#### Start Your Node

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

## Create Testnet Validator

This section applies to those who are looking to join the testnet post genesis.

1. Init Chain and start your node

   ```sh
   > staked init <moniker-name> --chain-id=albatross-1
   ```

   After that, please follow all the instructions from [Start your validator node](#start-your-validator-node)

2. Create a local key pair

   ```sh
   > staked keys add <key-name>
   > staked keys show <key-name> -a
   ```

3. Request tokens from faucet: [TODO]

4. Create validator

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
