import PinataClient, { PinataPin, PinataPinResponse } from "@pinata/sdk";
import path from "path";
import { ethers } from "hardhat";

const pinata = new PinataClient({ pinataApiKey: process.env.PINATA_API_KEY!, pinataSecretApiKey: process.env.PINATA_API_SECRET});
const owner = new ethers.Wallet(process.env.PRIVATE_KEY!);

const CONTRACT_METADATA = {
    "name": "NasaFT",
    "description": "Just your neighborhood space objects barreling towards the planet we all live on. This is fine 0_0.",
    "image": "ipfs hash",
    "fee_recipient": owner.address
}
const IMAGE_PATH = path.join(__dirname, "..", "NasaFTLogo.png");

export async function publishContractMetadata()
{
    if ((await pinata.testAuthentication()).authenticated)
    {
        const image = await pinata.pinFromFS(IMAGE_PATH);
        if (image && image.IpfsHash)
        {
            CONTRACT_METADATA.image = image.IpfsHash;
            const metadata = await pinata.pinJSONToIPFS(CONTRACT_METADATA);
            if (metadata && metadata.IpfsHash)
            {
                console.log("Contract metadata hash: " + metadata.IpfsHash);
            }
            else 
            {
                throw new Error("Could not pin the contract metadata");
            }
        }
        else
        {
            throw new Error("Could not pin the contract image");
        }
    }
    else
    {
        throw new Error("Could not connect to pinata");
    }
}

export async function removeAllPinataPins()
{
    if ((await pinata.testAuthentication()).authenticated)
    {
        for await (const pin of pinata.getFilesByCount({}))
        {
            console.log(pin);
        }
    }
    else
    {
        throw new Error("Could not connect to pinata");
    }
}