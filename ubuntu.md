# Ubuntu Setup

## Install build tools

```bash
# update ubuntu
> sudo apt-get update

# install make
> sudo apt-get install build-essential

# install gcc
> sudo apt-get install cmake gcc
```

## Install Go

### x86

```bash
> wget https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
> tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz
```

Setup paths in .profile

```bash
> vi .profile
```

```bash
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
```

Verify Go was installed and paths were set correctly

```bash
> go version
> echo $GOPATH
```
