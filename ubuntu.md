# Setup a Validator on Ubuntu

## Install dependencies

```bash
# update ubuntu
> sudo apt-get update

# install make
> sudo apt-get install build-essential

# install gcc
> sudo apt-get install gcc
```

### Install Go

```bash
> wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
> tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz
```

Setup paths in .profile

```bash
> vi .profile
```

```bash
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
```

Verify go was installed and paths were set correctly

```bash
> go version
```
