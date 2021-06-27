/* eslint-disable space-before-function-paren */
/* eslint-disable no-undef */
const hre = require('hardhat');
const { deployed } = require('./deployed');

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // Optionnel car l'account deployer est utilisé par défaut
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  // We get the contract to deploy
  const MagnetRightsFactory = await hre.ethers.getContractFactory('MagnetRightsFactory');
  const magnetrightsfactory = await MagnetRightsFactory.deploy();

  // Attendre que le contrat soit réellement déployé, cad que la transaction de déploiement
  // soit incluse dans un bloc
  await magnetrightsfactory.deployed();

  MagnetRights = await ethers.utils.getContractAddress({
    from: magnetrightsfactory.address,
    nonce: await ethers.provider.getTransactionCount(magnetrightsfactory.address),
  });

  await deployed('magnetrightsfactory', hre.network.name, magnetrightsfactory.address);
  await deployed("Magnetrights", hre.network.name, MagnetRights);
  
}

  // Create/update deployed.json and print usefull information on the console.
  

 

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
