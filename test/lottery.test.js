const Lottery = artifacts.require("Lottery");

// 파라미터에 차례로 0번 주소, 1번 주소, 2번 주소 ... 이렇게 들어온다
contract('Lottery', function([deployer, user1, user2]){
    let lottery;
    beforeEach(async () => {
        console.log('Before each')

        lottery = await Lottery.new();
    })

    it('Basic test', async () => {
        console.log('Basic test')
        let owner = await lottery.owner();
        let value = await lottery.getSomeValue();

        console.log(`owner : ${owner}`);
        console.log(`value : ${value}`);
        assert.equal(value, 6)
    })
})