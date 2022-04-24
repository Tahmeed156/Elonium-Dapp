const { expect } = require("chai");

describe("Elonium", function () {

  let elonium;
  let owner;
  let addr1;

  beforeEach(async function () {
    const El = await ethers.getContractFactory("Elonium");
    [ owner ] = await ethers.getSigners();
    addr1 = await ethers.Wallet.createRandom();
    addr1 =  addr1.connect(ethers.provider);
    elonium = await El.deploy(process.env.UNITS_PER_CELO);
    await elonium.deployed();
  });

  describe("Basic", function () {
    it("Should return the name & symbol", async function () {
      expect(await elonium.symbol()).to.equal("ELM");
      expect(await elonium.name()).to.equal("Elonium");
    });
    
    it("Should have 1e6 CELO as initial supply and all assigned to owner", async function () {
      expect(await elonium.totalSupply()).to.equal("10000000000000000000000000");
      expect(await elonium.balanceOf(owner.address)).to.equal("10000000000000000000000000");
    });
  });
  
  describe("Receivers", function () {
    it("Should allow adding a receiver, checking existence & removing it", async function() {
      const addReceiverTx = await elonium.connect(owner).addReceiver(addr1.address);
      await addReceiverTx.wait();

      expect(await elonium.receiverExists(addr1.address)).to.equal(true);
      
      const removeReceiverTx = await elonium.connect(owner).removeReceiver(addr1.address);
      await removeReceiverTx.wait();

      expect(await elonium.receiverExists(addr1.address)).to.equal(false);
    });
  });
  
  describe("Burn", function () {
    it("Should allow owner to burn all tokens", async function() {
      const burnAllTokensTx = await elonium.connect(owner).burnAllTokens();
      await burnAllTokensTx.wait();

      expect(await elonium.balanceOf(owner.address)).to.equal("0");
      expect(await elonium.totalSupply()).to.equal("0");
    });
  });
  
  describe("Mint", function () {
    it("Should allow owner to mint an arbitrary number of tokens", async function() {

      let ownerBalance =  Number(await elonium.balanceOf(owner.address));
      let totalSupply =  Number(await elonium.totalSupply());

      // Mint 30 tokens

      let mintTokensTx = await elonium.connect(owner).mint(owner.address, 30);
      await mintTokensTx.wait();

      ownerBalance += 30;
      totalSupply += 30;

      expect(Number(await elonium.balanceOf(owner.address))).to.equal(ownerBalance);
      expect(Number(await elonium.totalSupply())).to.equal(totalSupply);

      // Mint another 80 tokens

      mintTokensTx = await elonium.connect(owner).mint(owner.address, 80);
      await mintTokensTx.wait();

      ownerBalance += 80;
      totalSupply += 80;

      expect(Number(await elonium.balanceOf(owner.address))).to.equal(ownerBalance);
      expect(Number(await elonium.totalSupply())).to.equal(totalSupply);
    });
  });
});
