# lottery-smart-contract

### Install truffle and ganache-cli
``` shell
$ npm install -g truffle
$ npm install -g ganache-cli
```
  
### Run contracts
``` shell
$ ganache-cli -d -m tutorial
```
  
### Deploy contracts
``` shell
$ cd lottery-smart-contract
$ truffle migrate --reset
2_deploy_smart_contract.js
==========================

   Replacing 'Lottery'
   -------------------
   > transaction hash:    0xfe0bff4e045edcc28b27859cf037e201061ba5ac8b525e062cbc433384b40c9e
   > Blocks: 0            Seconds: 0
   > contract address:    0x260c55d15b9d57d2dBf17e34794B69F22d03Fe9a
   > block number:        58
   > block timestamp:     1631077840
   > account:             0xF76c9B7012c0A3870801eaAddB93B6352c8893DB
   > balance:             89.84337674
   > gas used:            1236895 (0x12df9f)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.0247379 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:           0.0247379 ETH
```
The contract address is needed when linking with the [frontend](https://github.com/sdardew/lottery-react-app).  
  
Put the contract address into the variable lotteryAddress in the [App.js](https://github.com/sdardew/lottery-react-app/blob/main/src/App.js).


``` Solidity
pragma solidity >=0.4.22 <0.9.0;

contract Lottery {
    address public owner; // public으로 생성하면 자동으로 getter가 생성됨
    
    // smart contract가 생성될 때 가정 먼저 실행되는 함수
    // 배포가 될 때 실행되는 함수
    constructor() public {
        owner = msg.sender; // 보낸 사람으로 owner을 저장
    }

    function getSomeValue() public pure returns (uint256 value) {
        return 6;
    }
}
```
