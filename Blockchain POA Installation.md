# Install Besu hyperledger - IBFT 2.0

__December 21st, 2020__

## Prerequisites
- Docker and Docker-compose
- Nodejs  
- Git command line
- Curl command line
- Python pip

### Install Docker
apt install docker.io

### Install Docker-compose

Download package:

`curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

Apply executable permissions to the binary:

`chmod +x /usr/local/bin/docker-compose`

### Install Node.js v12.x:

```bash
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y nodejs
```

### Install Python pip3
`apt install python3-pip`


## Create Docker-compose file

`npx quorum-dev-quickstart`


### Note the ibft2genesis.json
```
{
  "config" : {
    "chainId" : 2018,
    "constantinoplefixblock" : 0,
    "ibft2" : {
      "blockperiodseconds" : 2,
      "epochlength" : 30000,
      "requesttimeoutseconds" : 10
    }
  },
  "nonce" : "0x0",
  "timestamp" : "0x58ee40ba",
  "gasLimit" : "0xf7b760",
  "difficulty" : "0x1",
  "mixHash" : "0x63746963616c2062797a616e74696e65206661756c7420746f6c6572616e6365",
  "extraData": "0xf87ea00000000000000000000000000000000000000000000000000000000000000000f854944592c8e45706cc08b8f44b11e43cba0cfc5892cb9406e23768a0f59cf365e18c2e0c89e151bcdedc7094c5327f96ee02d7bcbc1bf1236b8c15148971e1de94ab5e7f4061c605820d3744227eed91ff8e2c8908808400000000c0",
  "coinbase" : "0x0000000000000000000000000000000000000000",
  "alloc" : {
    "fe3b557e8fb62b89f4916b721be55ceb828dbd73" : {
      "privateKey" : "8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
      "comment" : "private key and this comment are ignored.  In a real chain, the private key should NOT be stored",
      "balance" : "0xad78ebc5ac6200000"
    },
    "627306090abaB3A6e1400e9345bC60c78a8BEf57" : {
      "privateKey" : "c87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3",
      "comment" : "private key and this comment are ignored.  In a real chain, the private key should NOT be stored",
      "balance" : "90000000000000000000000"
    },
    "f17f52151EbEF6C7334FAD080c5704D77216b732" : {
      "privateKey" : "ae6ae8e5ccbfb04590405997ee2d52d2b330726137b875053c36d94e974d162f",
      "comment" : "private key and this comment are ignored.  In a real chain, the private key should NOT be stored",
      "balance" : "90000000000000000000000"
    },
    "0x0000000000000000000000000000000000008888": {
      "comment": "Account Ingress smart contract",
      "balance": "0",
      "code": "0x6080604052.........2",
      "storage": {
        "0x0000000000000000000000000000000000000000000000000000000000000000": "0x72756c6573000000000000000000000000000000000000000000000000000000",
        "0x0000000000000000000000000000000000000000000000000000000000000001": "0x61646d696e697374726174696f6e000000000000000000000000000000000000",
        "0x0000000000000000000000000000000000000000000000000000000000000004": "0x0f4240"
      }
    },
    "0x0000000000000000000000000000000000009999": {
      "comment": "Node Ingress smart contract",
      "balance": "0",
      "code": "0x60806040523480...........005090032",
      "storage": {
        "0x0000000000000000000000000000000000000000000000000000000000000000": "0x72756c6573000000000000000000000000000000000000000000000000000000",
        "0x0000000000000000000000000000000000000000000000000000000000000001": "0x61646d696e697374726174696f6e000000000000000000000000000000000000",
        "0x0000000000000000000000000000000000000000000000000000000000000004": "0x0f4240"
      }
    }
  }
}
```

### Run the Blockchain
Run the command ./run.sh


# Clone TTS Token

`git clone https://github.com/napoliblockchain/ttstoken.git`

`cd ttstoken`

if we run into root user:

```
npm config set user 0
npm config set unsafe-perm true
```

then

```
npm install -g truffle
npm install truffle-privatekey-provider @openzeppelin/contracts@2.4.0
npm install
```

modify supply in contracts/TTSToken.sol
```
1e9 # 10.000.000,00
```

Modify truffle-config.js and insert correct parameters in privateKey and providerUrl.

### Install Vyper

`pip3 install vyper`


Then deploy the smart contract:

```
truffle compile
truffle migrate --network private --skipDryRun
```

Here are the informations of the new smart contract:
```
Starting migrations...
======================
> Network name:    'private'
> Network id:      2018
> Block gas limit: 16234336 (0xf7b760)


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > transaction hash:    0xcec28ed3505149ef2ea5d6e8fe58c01539d4a83a58a3887bdd345a2019fca9bc
   > Blocks: 0            Seconds: 0
   > contract address:    0x42699A7612A82f1d9C36148af9C77354759b210b
   > block number:        1261
   > block timestamp:     1608547452
   > account:             0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73
   > balance:             199.99472518
   > gas used:            263741 (0x4063d)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00527482 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00527482 ETH


2_token_migration.js
====================

   Deploying 'TTSToken'
   --------------------
   > transaction hash:    0x2d62f725445e42c2643c2eab99ba18fbe29cd85e8c5dee5b8d54b14c0271b463
   > Blocks: 0            Seconds: 0
   > contract address:    0x9a3DBCa554e9f6b9257aAa24010DA8377C57c17e
   > block number:        1263
   > block timestamp:     1608547456
   > account:             0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73
   > balance:             199.95463374
   > gas used:            1962549 (0x1df235)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.03925098 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.03925098 ETH


Summary
=======
> Total deployments:   2
> Final cost:          0.0445258 ETH

```
