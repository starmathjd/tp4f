import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

/**
 * Deploys a contract named "TokenA" (ERC20 token).
 * The constructor mints 1000 tokens to the deployer's address.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployTokenA: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  // Obtiene la cuenta del deployer
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Despliega el contrato TokenA
  const tokenADeployment = await deploy("TokenA", {
    from: deployer,
    args: [], // El constructor no necesita argumentos adicionales
    log: true,
    autoMine: true, // Minar automáticamente en redes locales
  });

  // Obtén el contrato TokenA desplegado para interactuar con él
  const tokenA = await hre.ethers.getContract<Contract>("TokenA", deployer);
  console.log("TokenA contract deployed at:", tokenA.address);

  // Verifica la cantidad de tokens que tiene el deployer (debe tener 1000 TKA)
  const deployerBalance = await tokenA.balanceOf(deployer);
  console.log(`Deployer balance: ${deployerBalance.toString()} TKA`);
};

export default deployTokenA;

// Etiquetas útiles si tienes varios scripts de despliegue
deployTokenA.tags = ["TokenA"];
