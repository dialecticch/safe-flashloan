import "@nomiclabs/hardhat-waffle";
import type {HardhatUserConfig} from "hardhat/types";

const userConfig: HardhatUserConfig = {
    paths: {
        sources: "./contracts",
        tests: "./test",
        cache: "./cache",
        artifacts: "./artifacts"
    },
    mocha: {
        timeout: 2000000,
    },
    solidity: "0.8.4",
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            forking: {
                url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`, // @TODO ENVIROMENT VAR
                blockNumber: 12921859
            },
            hardfork: "london"
        },
    },
};
export default userConfig