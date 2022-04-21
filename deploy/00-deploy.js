// deploy/00_deploy_my_contract.js
module.exports = async ({getNamedAccounts, deployments}) => {
  
  const {deploy} = deployments;
  const {deployer} = await getNamedAccounts();

  elm = await deploy('Elonium', {
    from: deployer,
    args: [100],
    log: true,
  });

  await deploy('Lori', {
    from: deployer,
    args: [elm.receipt.contractAddress, 100],
    log: true,
  });
};

module.exports.tags = ['Elonium', 'Lori'];