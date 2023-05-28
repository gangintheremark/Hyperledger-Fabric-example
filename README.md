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
