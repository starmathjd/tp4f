import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

/**
 * Deploys the SimpleDEX contract with the provided token addresses.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deploySimpleDEX: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Token addresses (these should already be deployed, you need their addresses)
  const tokenAAddress = "0x6255A0552540E5580f1828EAd01064B79F375bCC"; // Replace with the actual address of Token A
  const tokenBAddress = "0x13EE382BC0cbAdF3b2945542BE62e286CFb3cF6E"; // Replace with the actual address of Token B

  // Deploy the SimpleDEX contract
  const simpleDEXDeployment = await deploy("SimpleDEX", {
    from: deployer,
    args: [tokenAAddress, tokenBAddress], // Constructor arguments
    log: true,
    autoMine: true, // Automatically mines the deployment in local networks
  });

  // Get the deployed SimpleDEX contract to interact with it
  const simpleDEX = await hre.ethers.getContract<Contract>("SimpleDEX", deployer);
  console.log("SimpleDEX contract deployed at:", simpleDEX.address);

  // Optional: You can log some details about the deployed contract, like token addresses
  console.log("Token A Address:", tokenAAddress);
  console.log("Token B Address:", tokenBAddress);
};

export default deploySimpleDEX;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags SimpleDEX
deploySimpleDEX.tags = ["SimpleDEX"];
