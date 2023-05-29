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
 - .tar.gz 확장자로 패키징됨
2. **Install** : 각 peer에 패키지 설치
 - 각 peer에 chaincode 패키지가 물리적으로 설치 
 - 패키지는 별도의 패키지 id로 관리
3. **Approve** : 채널 구성원이 설치된 chaincode 정의를 승인
 - 설치된 패키지 정의에 대하여 채널 구성원이 승인
 - 승인은 org 단위로 수행하며 정해진 policy를 만족해야함
4. **Commit** : 한 조직에서 채널에 정의를 commit해 chaincode 활성화
 - 채널에 정의된 정책을 만족하는 승인이 모이면 하나의 조직에서 commit 가능
 - commit이 완료되면 각 peer들은 chaincode container를 생성하여 활성화 
