# lottery-smart-contract
Lottery Dapp
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
