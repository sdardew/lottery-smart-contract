const Lottery = artifacts.require("Lottery");
const { assert } = require("chai");
const assertRevert = require("./assertRevert");
const expectEvent = require('./expectEvent');
// 파라미터에 차례로 0번 주소, 1번 주소, 2번 주소 ... 이렇게 들어온다
contract('Lottery', function([deployer, user1, user2]){
    let lottery;
    let betAccount = 5 * 10 ** 15;
    let bet_block_interval = 3;
    beforeEach(async () => {
        lottery = await Lottery.new();
    })

    it('getPot should return current pot', async () => {
        let pot = await lottery.getPot();
        assert.equal(pot, 0)
    })

    describe.only('Bet', function() {
        it('should fail when the bet money is not 0.005 ETH', async () => {
            // Fail transaction
            await assertRevert(lottery.bet('0xab', {from : user1, value: 4000000000000000})) // error를 try-catch로 처리하는지 확인

            // transcation object {chainId, value, to, from, gas(Limit), gasPrice}

        })

        it('should fail when the bet money is not 0.005 ETH', async () => {
            // bet
            let receipt = await lottery.bet('0xab', {from : user1, value: betAccount})
            // console.log(receipt);
            let pot = await lottery.getPot();
            assert.equal(pot, 0);

            // check contract balance == 0.005
            let contractBalance = await web3.eth.getBalance(lottery.address); // truffle은 web3가 자동으로 제공되기 때문에 따로 provider을 사용하지 않아도 됨
            assert.equal(contractBalance, betAccount)

            // check bet info
            let currentBlockNumber = await web3.eth.getBlockNumber();
            let bet = await lottery.getBetInfo(0);

            assert.equal(bet.answerBlockNumber, currentBlockNumber + bet_block_interval);
            assert.equal(bet.bettor, user1);
            assert.equal(bet.challenges, '0xab');
            
            // check log
            await expectEvent.inLogs(receipt.logs, 'BET');
        })
    })

    describe.only('isMatch', function() {
        it('should be BettingResult.Win when two characters match', async () => {
            let blockHash = '0xab2cfc92182162a97edd055abfb230c98af2eb57547f43c6560829d699680fe0';
            let matchingResult = await lottery.isMatch('0xab', blockHash)

            assert.equal(matchingResult, 1);
        })
    })
})