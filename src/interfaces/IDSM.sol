// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

/**
 * @title Delegated Security Manager (DSM) Contract
 * @author Bread
 * @notice This is a security manager contract that allows for the delegation of security using Hats protocol
 */
interface IDSM {
  struct ExecutionParams {
    uint256 localAdminHatId;
    uint64 executionPeriod;
    uint64 nextExpiry;
  }

  /*///////////////////////////////////////////////////////////////
                            EVENTS
  //////////////////////////////////////////////////////////////*/
  /**
   * @notice Emitted when a contract is registered
   * @param _contract The address of the contract
   * @param _localAdminHatId The ID of the local admin hat
   * @param _executionPeriod The period of the execution
   */
  event RegisterContract(address indexed _contract, uint256 _localAdminHatId, uint64 _executionPeriod);

  /**
   * @notice Emitted when the execution of a contract is unlocked
   * @param _contract The address of the contract
   */
  event UnlockContractExecution(address indexed _contract);

  /*///////////////////////////////////////////////////////////////
                            ERRORS
  //////////////////////////////////////////////////////////////*/

  /// @notice Thrown when the caller is not authorized
  error NotAuthorized();
  /// @notice Thrown when the contract is not registered
  error NotRegistered();

  /*///////////////////////////////////////////////////////////////
                            LOGIC
  //////////////////////////////////////////////////////////////*/
  /**
   * @notice Unlocks the execution of a contract
   * @param _contract The address of the contract to unlock
   */
  function unlockContractExecution(address _contract) external;

  /**
   * @notice Registers a contract with the DSM
   * @param _contract The address of the contract to register
   * @param _localAdminHatId The ID of the local admin hat
   * @param _executionPeriod The period of the execution
   */
  function registerContract(address _contract, uint256 _localAdminHatId, uint64 _executionPeriod) external;

  /**
   * @notice Checks if a contract is executable
   * @param _contract The address of the contract to check
   * @param _caller The address of the caller
   * @return _permitted True if the contract is executable, false otherwise
   */
  function executable(address _contract, address _caller) external view returns (bool _permitted);

  /*///////////////////////////////////////////////////////////////
                            VARIABLES
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Returns the general admin hat ID for the DSM
   * @return _generalAdminHatId The ID of the general admin hat
   */
  function GENERAL_ADMIN_HAT_ID() external view returns (uint256 _generalAdminHatId);
}
