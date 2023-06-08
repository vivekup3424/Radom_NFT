//typescript interface
interface networkConfigItem {
    name?: string;
    ethUsdPriceFeed?: string;
}
interface networkConfigInfo {
    [key: number]: networkConfigItem;
}
export const networkConfig: networkConfigInfo = {
    5: {
        name: "goerli",
        ethUsdPriceFeed: "0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e",
    },
    11155111: {
        name: "sepolia",
        ethUsdPriceFeed: "0x694AA1769357215DE4FAC081bf1f309aDC325306",
    },
};

export const developmentChains = ["hardhat", "localhost"];

export const DECIMALS = 8;
export const INTIAL_ANSWER = 200000000000;
