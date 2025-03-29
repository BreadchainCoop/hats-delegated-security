// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';

contract IntegrationBase is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'));
  }
}
