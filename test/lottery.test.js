const Lottery = artifacts.require("Lottery");

// 파라미터에 차례로 0번 주소, 1번 주소, 2번 주소 ... 이렇게 들어온다
contract('Lottery', function([deployer, user1, user2]){
    let lottery;

    beforeEach(async () => {
        lottery = await Lottery.new();
    })

    it('getPot should return current pot', async () => {
        let pot = await lottery.getPot();
        assert.equal(pot, 0)
    })
})