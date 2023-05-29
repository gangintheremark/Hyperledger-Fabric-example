**fabric 네트워크 구동**을 위해 필요한 전반적인 기능을 수행</br>
✔️ Network 구동 : startnetwork.sh </br>
✔️ Channel 생성 및 참가 : createChannel.sh</br>
✔️ AnchorPeer 설정 : setAnchorPeerUpdate.sh</br>
✔️ Chaincode 설치 및 배포 수행 : deployCC.sh</br>
✔️ Network 종료 : networkdown.sh</br>

### startnetwork.sh
```bash
# 1. cryptogen 이용하여 organizations 디렉토리에 필요한 인증서와 pub/priv key 생성
cryptogen generate --config=./config/crypto-config-org1.yaml --output="organizations"
cryptogen generate --config=./config/crypto-config-org2.yaml --output="organizations"
cryptogen generate --config=./config/crypto-config-orderer.yaml --output="organizations"

# 2. configtxgen 이용하여 genesis block 생성
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block

# 3. docker-compose 수행 : orderer, peer, couchDB, container 구동
COMPOSE_FILES=docker/docker-compose-net.yaml
COMPOSE_FILES_COUCH=docker/docker-compose-couch.yaml
IMAGE_TAG=latest docker-compose -f $COMPOSE_FILES -f $COMPOSE_FILES_COUCH up -d 
```

***

### createchannel.sh
```bash
# variable
CHANNEL_NAME="mychannel"

# 1. configtxgen 이용하여 channel 트랜잭션 생성
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME

# 2. channel 트랜잭션을 이용한 channel 생성
peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.example.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA

# 3. 생성된 channel에 peers 참가

## peer0.org1.example.com 에 대한 환경변수 setting 필수 
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block
## peer0.org2.example.com 에 대한 환경변수 setting 필수 
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block 

# 4.생성된 channel에 peer0.org2 참가
```

***

### deployCC.sh

```bash
# variable
CC_NAME="basic"
CC_SRC_PATH="./chaincode/asset-transfer-basic"
CC_RUNTIME_LANGUAGE="golang"
CC_VERSION="1"
CHANNEL_NAME="mychannel"

# 1. chaincode 패키지 생성
peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} 

# 2. chaincode 패키지를 peer에 설치

## for org1
peer lifecycle chaincode install ${CC_NAME}.tar.gz 
## for org2
peer lifecycle chaincode install ${CC_NAME}.tar.gz 

# 3. 설치된 chaincode definition 승인 

## for org1
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence 1 
## for org2
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence 1 

# 4. chaincode commit
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} $PEER_CONN_PARMS --version ${CC_VERSION} --sequence 1 

# 5. test
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS -c '{"function":"InitLedger","Args":[]}'
```



