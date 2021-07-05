/* eslint-disable quotes */
/* eslint-disable no-undef */

const { expect } = require('chai');

describe('MagnetRights', function () {
  let deployer, lambdaUser, lambdaUser2, AdVitamAeternam, advitamaeternam, Aeternam, aeternam;
  const NAME = 'Arthur';
  const LASTNAME = 'Rimbaud';
  const TEXT_1 = 'Comme je descendais des fleuves impassibles...';
  const TEXT_HASHES_1 = ethers.utils.id(TEXT_1);
  const CERTIFICATE_URI_1 = '00000000000000000000000000';

  const MINTER_ROLE = ethers.utils.id('MINTER_ROLE');
  beforeEach(async function () {
    [deployer, lambdaUser, lambdaUser2] = await ethers.getSigners();

    AdVitamAeternam = await ethers.getContractFactory('AdVitamAeternam');

    advitamaeternam = await AdVitamAeternam.connect(deployer).deploy();

    await advitamaeternam.deployed();

    Aeternam = await ethers.getContractFactory('Aeternam');

    const aeternamAddress = await advitamaeternam.aeternam();

    aeternam = Aeternam.attach(aeternamAddress);
  });
  describe('AdVitamAeternam Deployement', async function () {
    it('Deployer should be owner', async function () {
      expect(await advitamaeternam.owner()).to.equal(deployer.address);
    });
    it('Should have return Aeternam address', async function () {
      expect(await advitamaeternam.aeternam()).to.equal(aeternam.address);
    });
    it('Should have zero profit in the smart contract', async function () {
      expect(await advitamaeternam.profit()).to.equal(0);
    });
    it('Should revert if owner tries to retrive 0 eth', async function () {
      await expect(advitamaeternam.connect(deployer).withdrawProfit()).to.revertedWith(
        'AdVitamAeternam: there is nothing to withdraw here!'
      );
    });
  });
  describe('Aeternam Deployment by proxy', async function () {
    it('Should have name Aeternam', async function () {
      expect(await aeternam.name()).to.equal('Aeternam');
    });
    it('Should have symbol AETER', async function () {
      expect(await aeternam.symbol()).to.equal('AETER');
    });
    it('Should have a total supply of zero', async function () {
      expect(await aeternam.totalSupply()).to.equal(0);
    });
    describe('Aeternam Access Control', async function () {
      it('AdVitamAeternam Master Contract should have the Minter Role', async function () {
        expect(await aeternam.hasRole(MINTER_ROLE, advitamaeternam.address)).to.be.true;
      });
      it("Should revert if non-minter tries to call 'immortalize'", async function () {
        await expect(
          aeternam.connect(lambdaUser).immortalize(TEXT_HASHES_1, lambdaUser.address, NAME, LASTNAME, CERTIFICATE_URI_1)
        ).to.be.reverted;
      });
      it("test", async function () {
        await expect(
          aeternam.connect(lambdaUser).immortalize(TEXT_HASHES_1, lambdaUser.address, NAME, LASTNAME, CERTIFICATE_URI_1)
        ).to.be.reverted;
      });
      it("Should mint an Aeternam if 'Immortalize' function is being called from AdVitamAeternam", async function () {
        await
        advitamaeternam
          .connect(lambdaUser)
          .immortalize(TEXT_HASHES_1, lambdaUser.address, TEXT_1, NAME, LASTNAME, CERTIFICATE_URI_1)
      });
    });
    describe('Aeternam Minting & Tracking', async function () {
      beforeEach(async function() {
        await expect(() => 
          advitamaeternam
            .connect(lambdaUser)
            .immortalize(TEXT_HASHES_1, lambdaUser.address, TEXT_1, NAME, LASTNAME, CERTIFICATE_URI_1)
        ).to.changeTokenBalance(aeternam, lambdaUser, 1);
      });
      it('Should mint a token to a user', async function () {
        expect(await aeternam.balanceOf(lambdaUser.address)).to.equal(1);
      });
      it('Should increase the totalSupply by one', async function() {
        expect(await aeternam.totalSupply()).to.equal(1)
      });
      it('First token, should be at index 0', async function() {
         tokenByIndex = await aeternam.tokenByIndex(0)
         expect(tokenByIndex).to.equal(1);
      });
      it('Second token, should be at index 1', async function() {
        await expect(() =>
          advitamaeternam
            .connect(lambdaUser)
            .immortalize(TEXT_HASHES_1, lambdaUser.address, TEXT_1, NAME, LASTNAME, CERTIFICATE_URI_1)
        ).to.changeTokenBalance(aeternam, lambdaUser, 1);
        tokenByIndex = await aeternam.tokenByIndex(1)
        expect(tokenByIndex).to.equal(2);
      });
      it('Should return the URI for the token minted', async function () {
        uri = await aeternam.tokenURI(1)
        expect(uri).to.equal('ipfs://00000000000000000000000000');
      });
    });
  });
});
