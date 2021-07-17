# Stargaze Cygnus X-1 Testnet Instructions: Part 1

![Alt Text](https://scitechdaily.com/images/Cygnus-X-1-System.gif)

## Minimum hardware requirements

- 2x CPUs
- 4GB RAM
- 50GB+ of disk space

## Software requirements

- [Ubuntu Setup Guide](./ubuntu.md)
- Latest version : [v0.10.0](https://github.com/public-awesome/stargaze/releases/tag/v0.10.0)

### Install Stargaze

#### Install Go

Stargaze is built using Go and requires Go version 1.16+. In this example, we will be installing Go on Ubuntu 20.04:

```sh
# First remove any existing old Go installation
sudo rm -rf /usr/local/go

# Install the latest version of Go using this helpful script
curl https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash

# Update environment variables to include go
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source $HOME/.profile
```

To verify that Go is installed:

```sh
go version
# Should return go version go1.16.4 linux/amd64
```

#### Build Stargaze from source

```sh
mkdir -p $GOPATH/src/github.com/public-awesome
cd $GOPATH/src/github.com/public-awesome
git clone https://github.com/public-awesome/stargaze && cd stargaze
git fetch origin --tags
git checkout v0.8.1
make build && make install
```

#### Verify installation

To verify if the installation was successful, execute the following command:

```sh
starsd version --long
```

It will display the version of `starsd` currently installed:

```sh
name: stargaze
server_name: starsd
version: 0.10.0
commit: eaa79abdf2942b143362aa15cfc204b4d977270b
build_tags: netgo,ledger
go: go version go1.16.4 linux/amd64
```

## Setup validator node

Below are the instructions to generate and submit your genesis transaction.

### Generate genesis transaction (gentx)

1. Initialize the Stargaze directories and create the local genesis file with the correct
   chain-id

   ```sh
   starsd config chain-id cygnusx-1
   # moniker is the name of your node
   starsd init <moniker>
   ```

2. Create a local key pair

   ```sh
   starsd keys add <key-name>
   ```

3. Add your account to your local genesis file with a given amount and the key you
   just created. Use only `1000000000000ustarx`, other amounts will be ignored.

   ```sh
   starsd add-genesis-account $(starsd keys show <key-name> -a) 1000000000000ustarx \
       --vesting-amount 1000000000000ustarx \
       --vesting-start-time 1626292800 \
       --vesting-end-time 1626379200
   ```

4. Generate the genesis transaction (gentx) that submits your validator info to the chain.
   The amount here is how much of your own funds you want to delegate to your validator (self-delegate).
   Start with 50% of your total (500000000000ustarx). You can always delegate the rest later.

   ```sh
   starsd gentx <key-name> 500000000000ustarx --chain-id=cygnusx-1
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
  git clone https://github.com/<github-username>/networks
  ```

- Copy the generated gentx json file to `<repo_path>/cygnusx-1/gentx/`

  ```sh
  cd networks
  cp ~/.starsd/config/gentx/gentx*.json ./cygnusx-1/gentx/
  ```

- Commit and push to your repo
- Create a PR onto https://github.com/public-awesome/networks

✨ Congrats! You have done everything you need to participate in the testnet. Now just hang tight for further instructions on starting your node when the network starts (7/13/2021 1600 UTC).
