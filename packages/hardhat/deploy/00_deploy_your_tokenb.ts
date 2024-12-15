import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

/**
 * Deploys a contract named "TokenB" (ERC20 token).
 * The constructor mints 1000 tokens to the deployer's address.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployTokenB: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  // Obtiene la cuenta del deployer
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Despliega el contrato TokenB
  const tokenBDeployment = await deploy("TokenB", {
    from: deployer,
    args: [], // El constructor no necesita argumentos adicionales
    log: true,
    autoMine: true, // Minar automáticamente en redes locales
  });

  // Obtén el contrato TokenB desplegado para interactuar con él
  const tokenB = await hre.ethers.getContract<Contract>("TokenB", deployer);
  console.log("TokenB contract deployed at:", tokenB.address);

  // Verifica la cantidad de tokens que tiene el deployer (debe tener 1000 TKB)
  const deployerBalance = await tokenB.balanceOf(deployer);
  console.log(`Deployer balance: ${deployerBalance.toString()} TKB`);
};

export default deployTokenB;

// Etiquetas útiles si tienes varios scripts de despliegue
deployTokenB.tags = ["TokenB"];
