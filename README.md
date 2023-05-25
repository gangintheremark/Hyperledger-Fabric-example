#### 네트워크 구동 스크립트
I. 준비물 생성
  - identity
  - genesis block
II. 네트워크 구성
  - docker-compose ( CA 2개, peer 2개, orderer )
III. 채널 구성 
`basic-network`
fabric 네트워크 구동을 위해 필요한 전반적인 기능을 수행
- 네트워크 구동 👉 startnetwork.sh
- 채널 생성 및 참가 👉 createChannel.sh
- 앵커피어 설정 👉 setAnchorPeerUpdate.sh
- 체인코드 설치 및 배포 수행 👉 deployCC.sh
- 네트워크 종료 👉 networkdown.sh

`basic-network/startnetwork.sh`
1. `cryptogen` 툴을 사용하여 organizations 디렉토리에 필요한 **인증서와 key** 생성
 - crypto-config-org1.yaml
 - crypto-config-org2.yaml
 - crypto-config-orderer.yaml
2. `configtxgen` 툴을 사용하여 **genesis block**생성
3. docker-compose 수행 : orderer, peer, couchdb container 구동
 - docker-compose-net.yaml
 - docker-compose-couch.yaml
