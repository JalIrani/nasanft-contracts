import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config({ path: __dirname+'/.env' });
import PinataClient, { PinataPin, PinataPinResponse } from "@pinata/sdk";
import path from "path";

const { API_URL, PRIVATE_KEY, PINATA_API_KEY, PINATA_API_SECRET } = process.env;

task("unpin", "Unpins all pinata metadata", async () => {
  const pinata = new PinataClient({ pinataApiKey: PINATA_API_KEY, pinataSecretApiKey: PINATA_API_SECRET});

  for await (const pin of pinata.getFilesByCount({status: "pinned"}))
  {
    try {
      await pinata.unpin((pin as PinataPin).ipfs_pin_hash);
    }
    catch(error) {
      console.log(error);
    }
  }
});

task("pin", "Pins the contract metadata and prints ipfs hash", async (args, hre) => {
  const pinata = new PinataClient({ pinataApiKey: PINATA_API_KEY, pinataSecretApiKey: PINATA_API_SECRET});
  const owner = new hre.ethers.Wallet(PRIVATE_KEY!);
  const IMAGE_PATH = path.join(__dirname, "NasaFTLogo.png");
  const image = await pinata.pinFromFS(IMAGE_PATH);
  const CONTRACT_METADATA = {
    "name": "NasaFT",
    "description": "Just your neighborhood space objects barreling towards the planet we all live on. This is fine 0_0.",
    "image": image.IpfsHash,
    "fee_recipient": owner.address
  }
  const metadata = await pinata.pinJSONToIPFS(CONTRACT_METADATA);
  console.log("Contract metadata hash: " + metadata.IpfsHash);
});

const config: HardhatUserConfig = {
  networks: {
    polygon_mumbai: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  },
  solidity: "0.8.17",
};

export default config;
