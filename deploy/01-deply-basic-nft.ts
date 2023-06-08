import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { developmentChains } from "../helper-hardhat-config";
import { ETHERSCAN_API_KEY } from "../hardhat.config";
import verify from "../utils/verify";
const deployBasicNFT: DeployFunction = async (
    hre: HardhatRuntimeEnvironment
) => {
    const { deployments, getNamedAccounts, network } = hre;
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const chainId = network.config.chainId;
    const basicNFT = await deploy("BasicNFT", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: 1,
    });
    if (!developmentChains.includes(network.name) && ETHERSCAN_API_KEY) {
        await verify(basicNFT.address, []);
    }
};
export default deployBasicNFT;
deployBasicNFT.tags = ["all", "basicNFT"];
