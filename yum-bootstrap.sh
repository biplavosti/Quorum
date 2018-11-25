#!/bin/bash
#set -eu -o pipefail

# install build deps
sudo dnf copr enable ppa:ethereum/ethereum
sudo yum update
sudo yum install -y build-essential make unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner software-properties-common maven
sudo yum install golang-go

sudo dnf copr enable ppa:webupd8team/java
sudo yum update
sudo yum install oracle-java8-installer

mkdir $HOME/lib
cd $HOME/lib
git clone https://github.com/jpmorganchase/quorum.git
cd $HOME/lib/quorum/
git checkout tags/v2.1.0
make all

mkdir $HOME/bin
cp $HOME/lib/quorum/build/bin/geth $HOME/bin/
cp $HOME/lib/quorum/build/bin/bootnode $HOME/bin/

cd $HOME/lib
wget -q https://github.com/jpmorganchase/tessera/releases/download/tessera-0.6/tessera-app-0.6-app.jar
cp $HOME/lib/tessera-app-0.6-app.jar $HOME/bin/tessera.jar

cd $HOME/Quorum

