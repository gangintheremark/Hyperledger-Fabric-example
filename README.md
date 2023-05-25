### 🌐네트워크 구동 스크립트🌐
I. **준비물 생성**
  - identity
  - genesis block
</br>
II. **네트워크 구성**
  - docker-compose ( CA 2개, peer 2개, orderer )
</br>
III. **채널 구성** 

----

📁`basic-network`
fabric 네트워크 구동을 위해 필요한 전반적인 기능을 수행</br>
✔️ Network 구동 👉 startnetwork.sh </br>
✔️ Channel 생성 및 참가 👉 createChannel.sh</br>
✔️ AnchorPeer 설정 👉 setAnchorPeerUpdate.sh</br>
✔️ Chaincode 설치 및 배포 수행 👉 deployCC.sh</br>
✔️ Network 종료 👉 networkdown.sh</br>

</br>

📝`basic-network/startnetwork.sh`
1. `cryptogen` 툴을 사용하여 organizations 디렉토리에 필요한 **인증서와 key** 생성</br>
📝 crypto-config-org1.yaml</br>
📝 crypto-config-org2.yaml</br>
📝 crypto-config-orderer.yaml</br>
2. `configtxgen` 툴을 사용하여 **genesis block**생성
3. `docker-compose` 수행 : orderer, peer, couchdb container 구동</br>
📝 docker-compose-net.yaml</br>
📝 docker-compose-couch.yaml</br>
