#!/bin/bash
set -u
set -e

echo "[*] Cleaning up temporary data directories"
rm -rf qdata
mkdir -p qdata/logs

echo "[*] Configuring node 1"
mkdir -p qdata/dd1
echo "" > qdata/dd1/password.txt
#cp permissioned-nodes.json qdata/dd1/static-nodes.json
#cp permissioned-nodes.json qdata/dd1/

geth --datadir qdata/dd1 init genesis.json
bootnode -genkey qdata/dd1/geth/nodekey
bootnode -nodekey qdata/dd1/geth/nodekey -writeaddress
#Initialise Tessera configuration
./tessera-init.sh
