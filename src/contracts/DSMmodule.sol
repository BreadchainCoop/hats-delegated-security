// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {IDSM} from 'interfaces/IDSM.sol';

/**
 * @title DSM Module
 * @notice This is a module that allows for the delegation of security using Hats protocol
 * @dev This module should be inherited by any contract that wants to use the DSM
 */
contract DSMmodule {
  IDSM public immutable DSM;

  /// @notice Modifier to check if the caller is authorized and the contract is executable
  modifier onlyAdmin() {
    if (!DSM.executable(address(this), msg.sender)) revert IDSM.NotAuthorized();
    _;
  }

  /// @notice Constructor to initialize the DSM module
  /// @param _dsm The address of the DSM contract
  constructor(address _dsm) {
    DSM = IDSM(_dsm);
  }
}
