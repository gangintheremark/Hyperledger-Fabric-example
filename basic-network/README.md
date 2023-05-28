📝`basic-network/startnetwork.sh`</br>
1. `cryptogen` 툴을 사용하여 organizations 디렉토리에 필요한 **인증서와 key** 생성</br>
📝 crypto-config-org1.yaml</br>
📝 crypto-config-org2.yaml</br>
📝 crypto-config-orderer.yaml
```bash
# 올바른 binary file 접근 위한 환경변수 
export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

# crypto material 생성
subinfoln "Creating Org1 Identities"

set -x
cryptogen generate --config=./config/crypto-config-org1.yaml --output="organizations"
res=$?
{ set +x; } 2>/dev/null

subinfoln "Creating Org2 Identities"

set -x
cryptogen generate --config=./config/crypto-config-org2.yaml --output="organizations"
res=$?
{ set +x; } 2>/dev/null

subinfoln "Creating Orderer Org Identities"

set -x
cryptogen generate --config=./config/crypto-config-orderer.yaml --output="organizations"
res=$?
{ set +x; } 2>/dev/null
```

2. `configtxgen` 툴을 사용하여 **genesis block**생성
```bash
set -x
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block
{ set +x; } 2>/dev/null
```

3. `docker-compose` 수행 : orderer, peer, couchdb container 구동</br>
📝 docker-compose-net.yaml</br>
📝 docker-compose-couch.yaml</br>
```bash
COMPOSE_FILES=docker/docker-compose-net.yaml
# IMAGE_TAG=latest docker-compose -f $COMPOSE_FILES up -d 2>&1
COMPOSE_FILES_COUCH=docker/docker-compose-couch.yaml
IMAGE_TAG=latest docker-compose -f $COMPOSE_FILES -f $COMPOSE_FILES_COUCH up -d 2>&1

```

----

</br>

📝`basic-network/createchannel.sh`</br>
1. `configtxgen` 툴을 사용하여 **channel 생성 트랜잭션** 생성
```bash
infoln "Generating channel create transaction '${CHANNEL_NAME}.tx'"
set -x
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
{ set +x; } 2>/dev/null
```
2. channel 트랜잭션을 이용한 **channel 생성**
```bash
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
set -x
peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.example.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA >&log.txt
{ set +x; } 2>/dev/null
```
3. 생성된 채널에 **peer 참가** (peer0.org1)
```bash
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
```
3. 생성된 채널에 **peer 참가** (peer0.org2)
```bash
infoln "Joining org2 peer to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
```