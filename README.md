# 1주차 네트워크 구동 
I. **준비물 생성** 👉 `identity` `genesis block`
  1. organizatons dir : 모든 멤버들의 id들이 생성되는 폴더
  2. channel - artifacts/channel.tx
  3. system-genesis-block / genesis.block
  4. startnetwork.sh (configtxgen, cryptogen 명령)

II. **네트워크 구성** </br>
✔️ 2 organizations ( org1 and org2 )</br>
✔️ 2 peers ( one peer for each organization )</br>
✔️ 2 couchdb ( one couchdb for each peer )</br>
  1. `docker-compose` : **ca, peer, couchDB, orderer** container 수행

III. **채널 구성** 
  1. **채널 생성** mychannel.tx 👉 mychannel.block `createchannel.sh`
  2. **채널에 peer 조인** mychannel.block 👉 peer0.org1.example.com
  3. **채널에 peer 조인** mychannel.block 👉 peer0.org2.example.com
  4. **앵커피어** 설정 `setAnchorpeerUpdate.sh`

</br>

# 2주차 chaincode lifecycle
1. **package** : chaincode 패키지 생성
2. **Install** : 각 peer에 패키지 설치
3. **Approve** : 채널 구성원이 설치된 chaincode 정의를 승인
4. **Commit** : 한 조직에서 채널에 정의를 commit해 chaincode 활성화

