/* eslint-disable no-undef */
async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const AnimalsFunding = await ethers.getContractFactory("AnimalsFunding");
  const animalsFunding = await AnimalsFunding.deploy();

  console.log("Contract address:", await  animalsFunding.address);
}

main()
 .then(() => process.exit(0))
 .catch(error => {
   console.error(error);
   process.exit(1);
 });