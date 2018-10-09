#!/bin/bash
set -u
set -e

function usage() {
  echo ""
  echo "Usage:"
  echo "    $0 [--tesseraJar path to Tessera jar file] [--remoteDebug] [--jvmParams \"JVM parameters\"]"
  echo ""
  echo "Where:"
  echo "    --tesseraJar specifies path to the jar file, default is to use the vagrant location"
  echo "    --remoteDebug enables remote debug on port 500n for each Tessera node (for use with JVisualVm etc)"
  echo "    --jvmParams specifies parameters to be used by JVM when running Tessera"
  echo "Notes:"
  echo "    Tessera jar location defaults to ${defaultTesseraJarExpr};"
  echo "    however, this can be overridden by environment variable TESSERA_JAR or by the command line option."
  echo ""
  exit -1
}

currentDir=`pwd`
defaultTesseraJarExpr="$HOME/bin/tessera.jar"
set +e
defaultTesseraJar=`find ${defaultTesseraJarExpr} 2>/dev/null`
set -e
if [[ "${TESSERA_JAR:-unset}" == "unset" ]]; then
  tesseraJar=${defaultTesseraJar}
else
  tesseraJar=${TESSERA_JAR}
fi

remoteDebug=false
jvmParams=
while (( "$#" )); do
  case "$1" in
    --tesseraJar)
      tesseraJar=$2
      shift 2
      ;;
    --remoteDebug)
      remoteDebug=true
      shift
      ;;
    --jvmParams)
      jvmParams=$2
      shift 2
      ;;
    --help)
      shift
      usage
      ;;
    *)
      echo "Error: Unsupported command line parameter $1"
      usage
      ;;
  esac
done

if [  "${tesseraJar}" == "" ]; then
  echo "ERROR: unable to find Tessera jar file using TESSERA_JAR envvar, or using ${defaultTesseraJarExpr}"
  usage
elif [  ! -f "${tesseraJar}" ]; then
  echo "ERROR: unable to find Tessera jar file: ${tesseraJar}"
  usage
fi

    DDIR="qdata/c1"
    mkdir -p ${DDIR}
    mkdir -p qdata/logs
    rm -f "$DDIR/tm.ipc"

    DEBUG=""
    if [ "$remoteDebug" == "true" ]; then
      DEBUG="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=500$i -Xdebug"
    fi

    #Only set heap size if not specified on command line
    MEMORY=
    if [[ ! "$jvmParams" =~ "Xm" ]]; then
      MEMORY="-Xms128M -Xmx128M"
    fi

    CMD="java $jvmParams $DEBUG $MEMORY -jar ${tesseraJar} -configfile $DDIR/tessera-config.json"
    echo "$CMD >> qdata/logs/tessera.log 2>&1 &"
    ${CMD} >> "qdata/logs/tessera.log" 2>&1 &
    sleep 1

echo "Waiting until all Tessera nodes are running..."
DOWN=true
k=10
while ${DOWN}; do
    sleep 1
    DOWN=false
        if [ ! -S "qdata/c1/tm.ipc" ]; then
            echo "Node 1 is not yet listening on tm.ipc"
            DOWN=true
        fi

        set +e
        result=$(printf 'GET /upcheck HTTP/1.0\r\n\r\n' | nc -Uv qdata/c1/tm.ipc | tail -n 1)
        set -e
        if [ ! "${result}" == "I'm up!" ]; then
            echo "Node 1 is not yet listening on http"
            DOWN=true
        fi

    k=$((k - 1))
    if [ ${k} -le 0 ]; then
        echo "Tessera is taking a long time to start.  Look at the Tessera logs in qdata/logs/ for help diagnosing the problem."
    fi
    echo "Waiting for Tessera node to start..."

    sleep 5
done

echo "Tessera node started"
exit 0
