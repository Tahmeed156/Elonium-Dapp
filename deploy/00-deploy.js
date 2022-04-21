// deploy/00_deploy_my_contract.js
module.exports = async ({getNamedAccounts, deployments}) => {
  const {deploy} = deployments;
  const {deployer} = await getNamedAccounts();
  await deploy('Elonium', {
    from: deployer,
    args: [100],
    log: true,
  });
};
module.exports.tags = ['Elonium'];