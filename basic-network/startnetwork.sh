#!/bin/bash

C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_RESET='\033[0m'

function infoln() {
  echo -e "${C_YELLOW}${1}${C_RESET}"
}

function subinfoln() {
  echo -e "${C_BLUE}${1}${C_RESET}"
}

infoln "Tear down running network"
./networkdown.sh

# 올바른 binary file 접근 위한 환경변수 !! 중요 
export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

# clean up the MSP directory
if [ -d "organizations/peerOrganizations" ]; then
    rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
fi

# Create crypto material using cryptogen 
infoln "Generating certificates using cryptogen tool"

subinfoln "Creating Org1 Identities"
#org1
set -x
cryptogen generate --config=./config/crypto-config-org1.yaml --output="organizations"
res=$?
{ set +x; } 2>/dev/null

subinfoln "Creating Org2 Identities"
#org2
set -x
cryptogen generate --config=./config/crypto-config-org2.yaml --output="organizations"
res=$?
{ set +x; } 2>/dev/null

subinfoln "Creating Orderer Org Identities"
#orderer
set -x
cryptogen generate --config=./config/crypto-config-orderer.yaml --output="organizations"
res=$?
{ set +x; } 2>/dev/null


# Create genesis block using configtxgen
infoln "------------- Generating Orderer Genesis block"
set -x
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block
{ set +x; } 2>/dev/null

# Bring up the peer and orderer nodes using docker compose.
infoln "------------- Bring up the peer and orderer nodes using docker compose"

COMPOSE_FILES=docker/docker-compose-net.yaml
# IMAGE_TAG=latest docker-compose -f $COMPOSE_FILES up -d 2>&1
COMPOSE_FILES_COUCH=docker/docker-compose-couch.yaml
IMAGE_TAG=latest docker-compose -f $COMPOSE_FILES -f $COMPOSE_FILES_COUCH up -d 2>&1

docker ps -a