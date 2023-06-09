import { assert, expect } from "chai";
import { log } from "console";
import { deployments, ethers, getNamedAccounts, network } from "hardhat";
import { developmentChains } from "../../helper-hardhat-config";
import { BasicNFT } from "../../typechain-types";
//do uint test only on development chains

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("Basic NFT unit test", () => {
          let basicNFT: BasicNFT;
          const sendValue = ethers.utils.parseEther("0.01");
          let deployer: string;
          beforeEach(async () => {
              //deploy BasicNFT contract before testing it
              deployer = (await getNamedAccounts()).deployer;
              await deployments.fixture(["basicNFT"]); //it helps to run the only basicNFT deploy script
              basicNFT = await ethers.getContract("BasicNFT", deployer);
          });
          //now start writing the tests
          describe("Token Counter", () => {
              it("the default value of Token Counter is saved correctly", async () => {
                  const response = await basicNFT.getTokenCounter();
                  const expectedValue = 0;
                  expect(response).to.equal(
                      expectedValue,
                      "The default value of token counter is not 0"
                  );
              });
          });
          describe("Constructor", () => {
              it("initializes the NFT correctly", async () => {
                  const name = await basicNFT.name();
                  const symbol = await basicNFT.symbol();
                  const TOKEN_URI = await basicNFT.TOKEN_URI();
                  const expectedValue =
                      "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
                  expect(name).to.equal("Doggie", "Name of NFT is not correct");
                  expect(symbol).to.equal(
                      "DOG",
                      "Symbol of NFT is not correct"
                  );
                  expect(TOKEN_URI).to.equal(
                      expectedValue,
                      "Token URI is not correct"
                  );
              });
          });
          //test-03
          describe("Mint NFT", () => {
              beforeEach(async () => {
                  const transactionResponse = await basicNFT.mintNFT();
                  transactionResponse.wait(2);
              });
              it("Generates NFT correctly", async () => {
                  const TOKEN_URI = await basicNFT.tokenURI(0);
                  const tokenCounter = await basicNFT.getTokenCounter();
                  console.log(`Token Counter = ${tokenCounter}`);
                  expect(tokenCounter).to.equal(
                      1,
                      "The Token Counter has not been updated correctly."
                  );
                  console.log(`TOKEN URI = ${TOKEN_URI}`);
                  expect(TOKEN_URI).to.equal(
                      await basicNFT.TOKEN_URI(),
                      "The id of NFT is not correct"
                  );
              });
              it("Shows the correct owner of the NFT", async () => {
                  const owner = await basicNFT.ownerOf("0"); //param is bignumerish
                  expect(owner).to.equal(
                      deployer,
                      "The owner of the NFT is not stored correctly"
                  );
              });
          });
      });
