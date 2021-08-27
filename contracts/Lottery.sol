// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery {
    struct BetInfo {
        uint256 answerBlockNumber;
        address payable bettor; // 돈을 내는 주소. 0.4.x버전 이후에서 부터는 돈을 보내기 위해서는 payable이라는 수식어가 필요하다.
        byte challenges; // 문제에 관한 정도
    }

    uint256 private _tail;
    uint256 private _head;
    mapping(uint256 => BetInfo) private _bets;
    address public owner;

    uint256 constant internal BLOCK_LIMIT = 256;
    uint256 constant internal BET_BLOCK_INTERVAL = 3;
    uint256 constant internal BET_AMOUNT = 5 * 10 ** 15; // internal: 내부에서만 -> 10 * 15는 0.001

    uint256 private _pot; // 팟머니를 저장

    enum BlockStatus {Checkable, NotRevealed, BlockLimitPassed}
    event BET(uint256 index, address bettor, uint256 amount, byte challenges, uint256 answerBlockNumber);
    constructor() public {
        owner = msg.sender;
    }

    // view: 스마트 컨트랙트에 변수를 조회하는 수식어
    function getPot() public view returns (uint256 pot) {
        return _pot;
    }

    /**
     * @dev 베팅을 한다. 유저는 0.005 ETH를 보내야 하고, 베팅용 1 byte 글자를 보낸다.
     * 큐에 저장된 베팅 정보는 이후 distribute 함수에서 해결한다.
     * @param challenges 유저가 베팅하는 글자
     * @return 함수가 잘 수행되었는지 확인하는 bool
     */
    function bet(byte challenges) public payable returns (bool result) {
        // Check the proper ether is sent
        require(msg.value == BET_AMOUNT, "Not enough ETH");

        // Push bet to the queue
        require(pushBet(challenges), "Fail to add a new Bet");

        // Emit event
        emit BET(_tail - 1, msg.sender, msg.value, challenges, block.number + BET_BLOCK_INTERVAL);

        return true;
    }
    

    // Distribute: 검증
    function distribute() public {
        uint256 cur;
        BetInfo memory b;
        BlockStatus currentBlockStatus;
        for(cur=_head;cur<_tail; cur++) {
            b = _bets[cur];
            currentBlockStatus = getBlockStatus(b.answerBlockNumber);

            // 정답을 확인하기 위해서는 정답 블록보다 현재 마이닝된 블록이 더 커야 한다
            // Checkable : block.number > AnswerBlockNumber && block.number < BLOCK_LIMIT + AnswerBlockNumber
            if(currentBlockStatus == BlockStatus.Checkable) {
                // if win, bettor gets pot

                // if fail, bettor's money goes pot

                // if draw, bettor's money
            }

            // Not Revealed: block.number <= AnswerBlockNumber
            if(currentBlockStatus == BlockStatus.NotRevealed) {
                break;
            }

            // Block Limit Passed: bock.number >= AnswerBlockNumber + BLOCK_LIMIT
            if(currentBlockStatus == BlockStatus.BlockLimitPassed) {
                // refund
                // emit refund
            }
            popBet(cur);

        }
    }
    
    function getBlockStatus(uint256 answerBlockNumber) internal view returns (BlockStatus) {
        if(block.number > answerBlockNumber && block.number < BLOCK_LIMIT + answerBlockNumber) {
            return BlockStatus.Checkable;
        }

        if(block.number <= answerBlockNumber) {
            return BlockStatus.NotRevealed;
        }

        if(block.number >= answerBlockNumber + BLOCK_LIMIT) {
            return BlockStatus.BlockLimitPassed;
        }

        return BlockStatus.BlockLimitPassed;
    }

    function getBetInfo(uint256 index) public view returns (uint256 answerBlockNumber, address bettor, byte challenges) {
        BetInfo memory b = _bets[index];
        answerBlockNumber = b.answerBlockNumber;
        bettor = b.bettor;
        challenges = b.challenges;
    }

    function pushBet(byte challenges) internal returns(bool) {
        BetInfo memory b;
        b.bettor = msg.sender; // 20byte
        b.answerBlockNumber = block.number + BET_BLOCK_INTERVAL; // 32byte
        b.challenges = challenges; // byte

        _bets[_tail] = b;
        _tail++; // 32byte 변홬

        return true;
    }

    function popBet(uint index) internal returns (bool) {
        delete _bets[index]; // delete를 하면 가스를 돌려 받는다 => 필요없는 데이터는 지워주는 것이 좋음
        return true;
    }
}