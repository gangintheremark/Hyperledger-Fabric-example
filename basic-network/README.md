**fabric 네트워크 구동**을 위해 필요한 전반적인 기능을 수행</br>
✔️ Network 구동 : startnetwork.sh </br>
✔️ Channel 생성 및 참가 : createChannel.sh</br>
✔️ AnchorPeer 설정 : setAnchorPeerUpdate.sh</br>
✔️ Chaincode 설치 및 배포 수행 : deployCC.sh</br>
✔️ Network 종료 : networkdown.sh</br>

📝`basic-network/startnetwork.sh`</br>
1. `cryptogen` 툴을 사용하여 organizations 디렉토리에 필요한 **인증서와 pub/priv key** 생성</br>
📄 crypto-config-org1.yaml</br>
📄 crypto-config-org2.yaml</br>
📄 crypto-config-orderer.yaml

```bash
cryptogen generate --config=./config/crypto-config-org1.yaml --output="organizations"
cryptogen generate --config=./config/crypto-config-org2.yaml --output="organizations"
cryptogen generate --config=./config/crypto-config-orderer.yaml --output="organizations"
```

2. `configtxgen` 툴을 사용하여 **genesis block**생성

```bash
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block
```

3. `docker-compose` 수행 : orderer, peer, couchdb container 구동</br>
📄 docker-compose-net.yaml</br>
📄 docker-compose-couch.yaml</br>

```bash
COMPOSE_FILES=docker/docker-compose-net.yaml
COMPOSE_FILES_COUCH=docker/docker-compose-couch.yaml
IMAGE_TAG=latest docker-compose -f $COMPOSE_FILES -f $COMPOSE_FILES_COUCH up -d 
```

***

📝`basic-network/createchannel.sh`</br>
1. `configtxgen` 툴을 사용하여 **channel 생성 트랜잭션** 생성
```bash
CHANNEL_NAME="mychannel"
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
```
2. channel 트랜잭션을 이용한 **channel 생성**
```bash
peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.example.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA
```
3. 생성된 채널에 **peer 참가** (peer0.org1)
```bash
# peer0.org1.example.com 에 대한 환경변수 setting 필수 

peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
```
3. 생성된 채널에 **peer 참가** (peer0.org2)
```bash
# peer0.org2.example.com 에 대한 환경변수 setting 필수 

peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
```