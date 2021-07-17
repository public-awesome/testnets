# Stargaze Cygnus X-1 Testnet Instructions: Part 2

![Alt Text](https://scitechdaily.com/images/Cygnus-X-1-System.gif)

## TLDR

Block explorer: [https://explorer.cygnusx-1.publicawesome.dev/](https://explorer.cygnusx-1.publicawesome.dev/)

Genesis file: https://github.com/public-awesome/networks/releases/download/cygnusx-1-final/genesis.json

Hash: `sha256sum d5baa2f54fbd4b0c84967e0b8a59bfa26ee5da6230da44f1f13624626cb3e927`

Seeds: `b5c81e417113e283288c48a34f1d57c73a0c6682@seed.cygnusx-1.publicawesome.dev:36657`

Peers: https://hackmd.io/ruGVasSzR9iUhIirVff44Q?both

## Overview

Thank you for submitting a gentx! This guide will provide instructions on getting ready for the testnet.

**The Chain Genesis Time is 17:00 UTC on July 19, 2021.**

Please have your validator up and ready by this time, and be available for further instructions if necessary
at that time.

The primary point of communication for the genesis process will be the #validators
channel on the [Stargaze Discord](https://discord.gg/QeJWCrE).

## Instructions

This guide assumes that you have completed the tasks involved in [Part 1](cygnusx-1/part1.md). You should be running on a machine that meets the hardware requirements specified in Part 1 with Go installed. We are assuming you already have a daemon home (`$HOME/.starsd`) setup.

These examples are written targeting an Ubuntu 20.04 system. Relevant changes to commands should be made depending on the OS/architecture you are running on.

### Update starsd to v0.10.0

Please update to the `v0.10.0` tag and rebuild your binaries.

```sh
git clone https://github.com/public-awesome/stargaze
cd stargaze
git checkout v0.10.0

make install
```

### Verify installation

Verify that everything is OK.

```sh
starsd version --long

name: starsd
server_name: starsd
version: 0.10.0
commit: eaa79abdf2942b143362aa15cfc204b4d977270b
build_tags: netgo,ledger
go: go version go1.16.4 linux/amd64
```

If the software version does not match, then please check your `$PATH` to ensure the correct `starsd` is running.

### Save chain-id in config

Please save the chain-id to your `client.toml`. This will make it so you do not have to manually pass in the chain-id flag for every CLI command.

```sh
starsd config chain-id cygnusx-1
```

### Install and setup Cosmovisor

We highly recommend validators use cosmovisor to run their nodes. This will make low-downtime upgrades more smoother,
as validators don't have to manually upgrade binaries during the upgrade, and instead can preinstall new binaries, and
cosmovisor will automatically update them based on on-chain SoftwareUpgrade proposals.

You should review the docs for cosmovisor located here: https://docs.cosmos.network/master/run-node/cosmovisor.html

If you choose to use cosmovisor, please continue with these instructions:

Cosmovisor is currently located in the Cosmos SDK repo, so you will need to download that, build cosmovisor, and add it
to you PATH.

```sh
git clone https://github.com/cosmos/cosmos-sdk
cd cosmos-sdk
git checkout v0.42.7
make cosmovisor
cp cosmovisor/cosmovisor $GOPATH/bin/cosmovisor
cd $HOME
```

After this, you must make the necessary folders for cosmosvisor in your daemon home directory (`~/.starsd`).

```sh
mkdir -p ~/.starsd
mkdir -p ~/.starsd/cosmovisor
mkdir -p ~/.starsd/cosmovisor/genesis
mkdir -p ~/.starsd/cosmovisor/genesis/bin
mkdir -p ~/.starsd/cosmovisor/upgrades
```

Cosmovisor requires some ENVIRONMENT VARIABLES be set in order to function properly. We recommend setting these in
your `.profile` so it is automatically set in every session.

```
echo "# Setup Cosmovisor" >> ~/.profile
echo "export DAEMON_NAME=starsd" >> ~/.profile
echo "export DAEMON_HOME=$HOME/.starsd" >> ~/.profile
source ~/.profile
```

Finally, you should copy the starsd binary into the `cosmovisor/genesis` folder.

```
cp $GOPATH/bin/starsd ~/.starsd/cosmovisor/genesis/bin
```

This will create a new `.starsd` folder in your HOME directory.

### Generate genesis file

Stargaze comes with a script to generate the genesis file required to start the chain. Therefore, no single party is responsible for starting the chain. Each validator generates their own genesis file, which should be identical for all.

If you don't already have the `networks` repo cloned:

```sh
git clone https://github.com/public-awesome/networks
cd networks
```

Update to the latest:

```sh
git checkout master
git pull
```

Build the genesis file:

```sh
./build-genesis.sh
```

_NOTE: This can take 10-30 minutes depending on your setup._

Verify your genesis file was created properly:

```sh
sha256sum ~/.starsd/config/genesis.json
d5baa2f54fbd4b0c84967e0b8a59bfa26ee5da6230da44f1f13624626cb3e927
```

_NOTE: You will need to install [jq](https://stedolan.github.io/jq/download/) if you haven't already for the above to work_.

### Updates to config files

You should review the `config.toml` and `app.toml` that was generated when you ran `starsd init` last time.

When it comes the min gas fees, our recommendation is to leave this blank for now (charge no gas fees), to make the UX as seamless as possible
for users to be able to pay with IBC assets. So in `app.toml`:

```sh
minimum-gas-prices = ""
```

### Reset chain DB

There shouldn't be any chain database yet, but in case there is for some reason, you should reset it.

```sh
starsd unsafe-reset-all
```

### Start your node

Now that everything is setup and ready to go, you can start your node.

```sh
cosmovisor start
```

You will need some way to keep the process always running. If you're on linux, you can do this by creating a
service.

```sh
sudo tee /etc/systemd/system/starsd.service > /dev/null <<EOF
[Unit]
Description=Stargaze Daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) start
Restart=always
RestartSec=3
LimitNOFILE=4096

Environment="DAEMON_HOME=$HOME/.starsd"
Environment="DAEMON_NAME=starsd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"

[Install]
WantedBy=multi-user.target
EOF
```

Then update and start the node

```sh
sudo -S systemctl daemon-reload
sudo -S systemctl enable starsd
sudo -S systemctl start starsd
```

You can check the status with:

```sh
systemctl status starsd
```

## Conclusion

Good luck! See ya in the Discord!

---

_Disclaimer: This content is provided for informational purposes only, and should not be relied upon as legal, business, investment, or tax advice. You should consult your own advisors as to those matters. References to any securities or digital assets are for illustrative purposes only and do not constitute an investment recommendation or offer to provide investment advisory services. Furthermore, this content is not directed at nor intended for use by any investors or prospective investors, and may not under any circumstances be relied upon when making investment decisions._

This work is a derivative of ["Osmosis Genesis Validators Guide"](https://github.com/osmosis-labs/networks/genesis-validators.md), which is a derivative of ["Agoric Validator Guide"](https://github.com/Agoric/agoric-sdk/wiki/Validator-Guide) used under [CC BY](http://creativecommons.org/licenses/by/4.0/). The Agoric validator guide is itself is a derivative of ["Validating Kava Mainnet"](https://medium.com/kava-labs/validating-kava-mainnet-72fa1b6ea579) by [Kevin Davis](https://medium.com/@kevin_35106), used under [CC BY](http://creativecommons.org/licenses/by/4.0/). "Stargaze Cygnus X-1 Testnet Instructions" is licensed under [CC BY](http://creativecommons.org/licenses/by/4.0/) by [Stargaze](https://stargaze.fi/). It was extensively modified to be relevant to the Stargaze Chain.
