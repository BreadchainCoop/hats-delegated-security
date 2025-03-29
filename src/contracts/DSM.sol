// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {IHats} from 'hats-v1/interfaces/IHats.sol';
import {IDSM} from 'interfaces/IDSM.sol';

contract DSM is IDSM {
  mapping(address _contract => bool _registered) internal _registeredContracts;
  mapping(address _contract => ExecutionParams _conditions) internal _executionParams;

  /// @inheritdoc IDSM
  uint256 public immutable GENERAL_ADMIN_HAT_ID;

  /// @notice Hats protocol contract
  IHats private immutable HATS;

  /**
   * @notice Modifier to check if the caller is the general admin
   */
  modifier onlyGeneralAdmin() {
    if (!HATS.isAdminOfHat(msg.sender, GENERAL_ADMIN_HAT_ID)) revert NotAuthorized();
    _;
  }

  /**
   * @notice Modifier to check if the caller is the contract admin
   */
  modifier onlyContractAdmin(address _contract, address _caller) {
    if (!_registeredContracts[_contract]) revert NotRegistered();
    if (!HATS.isAdminOfHat(_caller, _executionParams[_contract].localAdminHatId)) revert NotAuthorized();
    _;
  }

  /**
   * @notice Constructor to initialize the DSM
   * @param _hats The address of the HATS contract
   * @param _generalAdminHatId The ID of the general admin hat
   */
  constructor(address _hats, uint256 _generalAdminHatId) {
    HATS = IHats(_hats);
    GENERAL_ADMIN_HAT_ID = _generalAdminHatId;
  }

  /// @inheritdoc IDSM
  function unlockContractExecution(address _contract) external onlyGeneralAdmin {
    _executionParams[_contract].nextExpiry = uint64(block.timestamp + _executionParams[_contract].executionPeriod);
    emit UnlockContractExecution(_contract);
  }

  /// @inheritdoc IDSM
  function registerContract(
    address _contract,
    uint256 _localAdminHatId,
    uint64 _executionPeriod
  ) external onlyGeneralAdmin {
    _registeredContracts[_contract] = true;
    _executionParams[_contract] =
      ExecutionParams({localAdminHatId: _localAdminHatId, executionPeriod: _executionPeriod, nextExpiry: uint64(0)});
    emit RegisterContract(_contract, _localAdminHatId, _executionPeriod);
  }

  /// @inheritdoc IDSM
  function executable(
    address _contract,
    address _caller
  ) external view onlyContractAdmin(_contract, _caller) returns (bool _permitted) {
    if (block.timestamp < _executionParams[_contract].nextExpiry) _permitted = true;
    else _permitted = false;
  }
}
