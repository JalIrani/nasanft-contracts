import { ethers } from "hardhat";

async function main() {
  const NasaFT = await ethers.getContractFactory("NasaFT");
  const nasaFT = await NasaFT.deploy();

  await nasaFT.deployed();
  const contractOwner = await nasaFT.contractOwner();

  console.log(`NasaFT deployed to ${nasaFT.address} with contract owner ${contractOwner}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
