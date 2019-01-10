#!/bin/bash
set -u
set -e

echo "[*] Cleaning up temporary data directories"
rm -rf qdata
mkdir -p qdata/logs

echo "[*] Configuring node"
mkdir -p qdata/dd1
echo "" > qdata/dd1/password.txt
#cp permissioned-nodes.json qdata/dd1/static-nodes.json
#cp permissioned-nodes.json qdata/dd1/

#initialize blockchain with genesis
geth --datadir qdata/dd1 init genesis.json

#generate a node key
bootnode -genkey qdata/dd1/geth/nodekey

#print enode id of the node
echo "enode hash : "
bootnode -nodekey qdata/dd1/geth/nodekey -writeaddress

#Initialise Tessera configuration
bash tessera-init.sh
