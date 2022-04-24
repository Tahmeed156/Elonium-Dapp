// deploy/00_deploy_my_contract.js
module.exports = async ({getNamedAccounts, deployments}) => {
  
  const {deploy} = deployments;
  const {deployer} = await getNamedAccounts();

  elm = await deploy('Elonium', {
    from: deployer,
    args: [process.env.UNITS_PER_CELO],
    log: true,
  });

  await deploy('Lori', {
    from: deployer,
    args: [elm.receipt.contractAddress, process.env.ELM_PER_NFT],
    log: true,
  });
};

module.exports.tags = ['Elonium', 'Lori'];