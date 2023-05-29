### 🌐네트워크 구동 스크립트🌐
I. **준비물 생성**
  - identity
  - genesis block 

II. **네트워크 구성**
  - docker-compose </br>
✔️ 2 organizations ( org1 and org2 )</br>
✔️ 2 peers ( one peer for each organization )</br>
✔️ 2 couchdb ( one couchdb for each peer )</br>

III. **채널 구성** 

----

📁`basic-network`  </br>
fabric 네트워크 구동을 위해 필요한 전반적인 기능을 수행</br>
✔️ Network 구동 👉 startnetwork.sh </br>
✔️ Channel 생성 및 참가 👉 createChannel.sh</br>
✔️ AnchorPeer 설정 👉 setAnchorPeerUpdate.sh</br>
✔️ Chaincode 설치 및 배포 수행 👉 deployCC.sh</br>
✔️ Network 종료 👉 networkdown.sh</br>

</br>

`1주차` </br>
I. **준비물 생성**
  1. organizatons dir : 모든 멤버들의 id들이 생성되는 폴더
  2. channel - artifacts/channel.tx
  3. system-genesis-block / genesis.block
  4. startnetwork.sh (configtxgen, cryptogen 명령)

II. **네트워크 구성**
  1. docker-compose 👉 ca, peer, couchDB, orderer container 수행
  2. **채널을 생성** mychannel.tx 👉 mychannel.block (createchannel.sh)
  3. **채널에 peer 조인** mychannel.block 👉 peer0.org1.example.com
  4. **채널에 peer 조인** mychannel.block 👉 peer0.org2.example.com
  5. **앵커피어** 설정 setAnchorpeerUpdate.sh

`2주차`</br>
I. 체인코드 패키징 👉 설치 👉 승인 👉 commit 
