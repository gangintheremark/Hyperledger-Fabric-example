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

</br>

📝`basic-network/createchannel.sh`</br>