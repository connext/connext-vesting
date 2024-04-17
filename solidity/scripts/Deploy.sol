// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ConnextVestingWallet} from 'contracts/ConnextVestingWallet.sol';

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {Script, console} from 'forge-std/Script.sol';

contract Deploy is Script {
  ConnextVestingWallet internal _veilConnextVestingWallet;
  ConnextVestingWallet internal _bootnodeConnextVestingWallet;

  uint256 internal constant _VEIL_TOTAL_AMOUNT = 4_000_000 ether;
  address internal constant _VEIL_OWNER = 0x031752691A639a411c60E2749F40A8B163eeBbb4;

  uint256 internal constant _BOOTNODE_TOTAL_AMOUNT = 450_000 ether;
  address internal constant _BOOTNODE_OWNER = 0x140a7D1824A16372913fA572c79c10FF77388F7e;

  function run() public {
    address deployer = vm.rememberKey(vm.envUint('DEPLOYER_PRIVATE_KEY'));

    require(_VEIL_TOTAL_AMOUNT > 0, '_VEIL_TOTAL_AMOUNT');
    require(_VEIL_OWNER != address(0), '_VEIL_OWNER');
    require(_BOOTNODE_TOTAL_AMOUNT > 0, '_BOOTNODE_TOTAL_AMOUNT');
    require(_BOOTNODE_OWNER != address(0), '_BOOTNODE_OWNER');

    vm.startBroadcast(deployer);
    _veilConnextVestingWallet = new ConnextVestingWallet(_VEIL_OWNER, _VEIL_TOTAL_AMOUNT);
    _bootnodeConnextVestingWallet = new ConnextVestingWallet(_BOOTNODE_OWNER, _BOOTNODE_TOTAL_AMOUNT);
    vm.stopBroadcast();

    require(_veilConnextVestingWallet.owner() == _VEIL_OWNER, 'veil owner');
    require(_veilConnextVestingWallet.TOTAL_AMOUNT() == _VEIL_TOTAL_AMOUNT, 'veil TOTAL_AMOUNT');
    require(_bootnodeConnextVestingWallet.owner() == _BOOTNODE_OWNER, 'bootnode owner');
    require(_bootnodeConnextVestingWallet.TOTAL_AMOUNT() == _BOOTNODE_TOTAL_AMOUNT, 'bootnode TOTAL_AMOUNT');
  }
}
