import { NasaFT } from "../typechain-types";

import { expect } from "chai";
import { ethers } from "hardhat";
const zeroAddress = "0x0000000000000000000000000000000000000000";
const notOwnerError ="Ownable: caller is not the owner";
const setUriError = "The uri for this token has already been set";

describe("NasaFT", function () {
  it("Should get the correct id of the newly minted tokens", async () => {
    const { nasaFT, owner, otherAccount } = await deployContract();

    const id0 = 0;
    const copies0 = 5;
    await expect(nasaFT.mintTokens(owner.address, 0, copies0))
      .to.emit(nasaFT, "TransferSingle")
      .withArgs(owner.address, zeroAddress, owner.address, id0, copies0);

    //Next Id should be 1
    const id1 = 1;
    const copies1 = 10;
    await expect(nasaFT.mintTokens(owner.address, 1, copies1))
      .to.emit(nasaFT, "TransferSingle")
      .withArgs(owner.address, zeroAddress, owner.address, id1, copies1);
  });
  it("Non owner minting should fail while owner minting should pass", async () => {
    const { nasaFT, owner, otherAccount } = await deployContract();

    // Owner Minting
    await expect(nasaFT.mintTokens(owner.address, 0, 45))
      .to.emit(nasaFT, "TransferSingle")
      .withArgs(owner.address, zeroAddress, owner.address, 0, 45);

    // Nonowner Minting
    await expect(
      nasaFT.connect(otherAccount).mintTokens(owner.address, 1, 30)
    ).to.be.revertedWith(notOwnerError);
  });
  it("Non owner transer should fail while owner transfer should pass", async () => {
    const { nasaFT } = await deployContract();
    const [owner, one, two, three] = await ethers.getSigners();

    await mintTokens(nasaFT, owner.address);

    // Owner transfer single
    await expect(nasaFT.safeTransferFrom(owner.address, one.address, 0, 25, []))
      .to.emit(nasaFT, "TransferSingle")
      .withArgs(owner.address, owner.address, one.address, 0, 25);

    // Owner transfer batch
    await expect(
      nasaFT.safeBatchTransferFrom(
        owner.address,
        two.address,
        [0, 1],
        [2, 3],
        []
      )
    )
      .to.emit(nasaFT, "TransferBatch")
      .withArgs(owner.address, owner.address, two.address, [0, 1], [2, 3]);

    // Nonowner single transfer
    await expect(
      nasaFT
        .connect(one)
        .safeTransferFrom(one.address, three.address, 0, 10, [])
    ).to.be.revertedWith(notOwnerError);

    // Nonowner batch transfer
    await expect(
      nasaFT
        .connect(two)
        .safeBatchTransferFrom(two.address, three.address, [0, 1], [3, 4], [])
    ).to.be.revertedWith(notOwnerError);
  });
  it("Non owner token balance check should fail while owner token balance check should pass", async () => {
    const { nasaFT, owner, otherAccount } = await deployContract();

    await mintTokens(nasaFT, owner.address);

    // Transfer to other account
    await nasaFT.safeBatchTransferFrom(
      owner.address,
      otherAccount.address,
      [0, 1, 2, 3],
      [2, 3, 5, 7],
      []
    );

    // Owner Single balance check
    expect(await nasaFT.balanceOf(otherAccount.address, 0)).to.equal(2);

    // Owner Batch balance check
    expect(
      await nasaFT.balanceOfBatch(
        [
          owner.address,
          owner.address,
          owner.address,
          owner.address,
          otherAccount.address,
          otherAccount.address,
          otherAccount.address,
          otherAccount.address,
        ],
        [0, 1, 2, 3, 0, 1, 2, 3]
      )
    ).to.eql(toBigNumberArray([43, 42, 40, 38, 2, 3, 5, 7]));

    // Nonowner Single balance check
    await expect(
      nasaFT.connect(otherAccount).balanceOf(otherAccount.address, 0)
    ).to.be.revertedWith(notOwnerError);

    // Nonowner Batch balance check
    await expect(
      nasaFT
        .connect(otherAccount)
        .balanceOfBatch([owner.address, otherAccount.address], [0, 1, 2, 3])
    ).to.be.revertedWith(notOwnerError);
  });
  it("Should be able to burn tokens", async () => {
    const { nasaFT, owner, otherAccount } = await deployContract();
    // Owner Minting
    await expect(nasaFT.mintTokens(owner.address, 0, 45))
      .to.emit(nasaFT, "TransferSingle")
      .withArgs(owner.address, zeroAddress, owner.address, 0, 45);
      
    // Owner Single balance check
    expect(await nasaFT.balanceOf(owner.address, 0)).to.equal(45);
    
    // Burn Tokens
    await expect(nasaFT.burnTokens(owner.address, 0, 45))
      .to.emit(nasaFT, "TransferSingle")
      .withArgs(owner.address, owner.address, zeroAddress, 0, 45);

    // Owner Single balance check
    expect(await nasaFT.balanceOf(owner.address, 0)).to.equal(0);
  });
  it("Should be able to set uri only once and get uri.", async () => {
    const { nasaFT, owner, otherAccount } = await deployContract();
    // Owner Minting
    await expect(nasaFT.mintTokens(owner.address, 0, 45))
      .to.emit(nasaFT, "TransferSingle")
      .withArgs(owner.address, zeroAddress, owner.address, 0, 45);
      
    // setUrl
    expect(await nasaFT.setUri(0, "test uri")).not.to.be.reverted;

    await expect(nasaFT.setUri(0, "test uri again")).to.be.revertedWith(setUriError);

    // Owner Single balance check
    expect(await nasaFT.uri(0)).to.equal("test uri");
  });
});

async function deployContract() {
  // Contracts are deployed using the first signer/account by default
  const [owner, otherAccount] = await ethers.getSigners();
  const NasaFT = await ethers.getContractFactory("NasaFT");
  const nasaFT = await NasaFT.deploy();
  await nasaFT.deployed();
  return { nasaFT, owner, otherAccount };
}

async function mintTokens(nasaFT: NasaFT, ownerAddress: string) {
  // Owner Minting
  await expect(nasaFT.mintTokens(ownerAddress, 0, 45))
    .to.emit(nasaFT, "TransferSingle")
    .withArgs(ownerAddress, zeroAddress, ownerAddress, 0, 45);

  // Owner Minting
  await expect(nasaFT.mintTokens(ownerAddress, 1, 45))
    .to.emit(nasaFT, "TransferSingle")
    .withArgs(ownerAddress, zeroAddress, ownerAddress, 1, 45);

  // Owner Minting
  await expect(nasaFT.mintTokens(ownerAddress, 2, 45))
    .to.emit(nasaFT, "TransferSingle")
    .withArgs(ownerAddress, zeroAddress, ownerAddress, 2, 45);

  // Owner Minting
  await expect(nasaFT.mintTokens(ownerAddress, 3, 45))
    .to.emit(nasaFT, "TransferSingle")
    .withArgs(ownerAddress, zeroAddress, ownerAddress, 3, 45);
}

function toBigNumberArray(numberArray: Number[]) {
  const bigNumberArray = [];
  for (var number of numberArray) {
    bigNumberArray.push(ethers.BigNumber.from(number));
  }
  return bigNumberArray;
}
