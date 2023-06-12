async function main() {
  const Fruits = await hre.ethers.getContractFactory('NFT721AToken');
  const FruitsDeploy = await Fruits.deploy(24 * 60 * 60);
  await FruitsDeploy.deployed();

  console.log('NFT721AToken deployed to:', FruitsDeploy.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
