#!/bin/bash
#set -eu -o pipefail

# install build deps
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y build-essential make unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner software-properties-common maven
sudo apt install golang-go

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

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

