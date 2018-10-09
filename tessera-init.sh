#!/usr/bin/env bash

echo "[*] Initialising Tessera configuration"

currentDir=$(pwd)
    DDIR="qdata/c1"
    mkdir -p ${DDIR}
    mkdir -p qdata/logs
    rm -f "${DDIR}/tm.ipc"

java -jar $HOME/bin/tessera.jar -keygen -filename  "tm"
#tessera -keygen -filename "${DDIR}/tm"
mv "tm.pub" "${DDIR}/tm.pub"
mv "tm.key" "${DDIR}/tm.key"

    #change tls to "strict" to enable it (don't forget to also change http -> https)
    cat <<EOF > ${DDIR}/tessera-config.json
{
    "useWhiteList": false,
    "jdbc": {
        "username": "sa",
        "password": "",
        "url": "jdbc:h2:./${DDIR}/db${i};MODE=Oracle;TRACE_LEVEL_SYSTEM_OUT=0"
    },
    "server": {
        "port": 9001,
        "hostName": "http://localhost",
        "sslConfig": {
            "tls": "OFF",
            "generateKeyStoreIfNotExisted": true,
            "serverKeyStore": "${currentDir}/qdata/c1/server-keystore",
            "serverKeyStorePassword": "quorum",
            "serverTrustStore": "${currentDir}/qdata/c1/server-truststore",
            "serverTrustStorePassword": "quorum",
            "serverTrustMode": "TOFU",
            "knownClientsFile": "${currentDir}/qdata/c1/knownClients",
            "clientKeyStore": "${currentDir}/qdata/c1/client-keystore",
            "clientKeyStorePassword": "quorum",
            "clientTrustStore": "${currentDir}/qdata/c1/client-truststore",
            "clientTrustStorePassword": "quorum",
            "clientTrustMode": "TOFU",
            "knownServersFile": "${currentDir}/qdata/c1/knownServers"
        }
    },
    "peer": [
        {
            "url": "http://localhost:9001"
        }
    ],
    "keys": {
        "passwords": [],
        "keyData": [
            {
                "config": $(cat ${DDIR}/tm.key),
                "publicKey": "$(cat ${DDIR}/tm.pub)"
            }
        ]
    },
    "alwaysSendTo": [],
    "unixSocketFile": "${DDIR}/tm.ipc"
}
EOF

