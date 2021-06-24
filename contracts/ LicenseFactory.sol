//SPDX-License-Identifier: MIT


pragma solidity ^0.8.5;

// Import Address for Address Payable, the function that will mint a contract will be payable, 
// See KingOfTheHill for that

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract LicenseFactory is AccessControl {

    using Address for address payable;
     
}