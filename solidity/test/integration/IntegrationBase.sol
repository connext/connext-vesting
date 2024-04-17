// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {Test} from 'forge-std/Test.sol';

import {Deploy} from 'scripts/Deploy.sol';
import {Constants} from 'test/utils/Constants.sol';

import {IVestingEscrowSimple} from 'interfaces/IVestingEscrowSimple.sol';
import {IVestingEscrowFactory} from 'test/utils/IVestingEscrowFactory.sol';

contract IntegrationBase is Test, Constants, Deploy {
  address public owner = _VEIL_OWNER;
  address public payer = makeAddr('payer');

  IERC20 internal _nextToken = IERC20(NEXT_TOKEN_ADDRESS);
  IVestingEscrowFactory internal _vestingEscrowFactory = IVestingEscrowFactory(VESTING_ESCROW_FACTORY_ADDRESS);
  IVestingEscrowSimple internal _vestingEscrow;

  function setUp() public virtual {
    vm.createSelectFork(vm.rpcUrl('mainnet'), FORK_BLOCK);
    uint256 _totalAmount = _VEIL_TOTAL_AMOUNT + _BOOTNODE_TOTAL_AMOUNT;

    // deploy
    run();

    deal(NEXT_TOKEN_ADDRESS, payer, _totalAmount);

    // approve before deployment
    vm.prank(payer);
    _nextToken.approve(address(_vestingEscrowFactory), _totalAmount);

    // deploy vesting contract
    vm.prank(payer);
    _vestingEscrow = IVestingEscrowSimple(
      _vestingEscrowFactory.deploy_vesting_contract({
        _token: NEXT_TOKEN_ADDRESS,
        _recipient: address(_veilConnextVestingWallet),
        _amount: _totalAmount,
        _vestingDuration: VESTING_DURATION,
        _vestingStart: AUG_01_2022,
        _cliffLength: 0,
        _openClaim: false,
        _supportVyper: 0
      })
    );
  }
}
