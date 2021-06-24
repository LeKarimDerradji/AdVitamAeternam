//SPDX-License-Identifier: MIT


pragma solidity ^0.8.5;

// Import Address for Address Payable, the function that will mint a contract will be payable, 
// See KingOfTheHill for that

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./MagnetRoyalities.sol";

// Un rôle pour les poètes, un rôle pour l'owner, un rôle pour celui qui vérifie 

contract LicenseFactory is AccessControl {

    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant CHECKER_ROLE = keccak256("CHECKER_ROLE");
    bytes32 public constant AUTHOR_ROLE = keccak256("AUTHOR_ROLE");


    using Address for address payable;
    
    MagnetRoyalities private _magnetroyalities;

       constructor() {
        _setupRole(OWNER_ROLE, msg.sender);
        _setRoleAdmin(CHECKER_ROLE, OWNER_ROLE);
        _setRoleAdmin(AUTHOR_ROLE, CHECKER_ROLE);
        _magnetroyalities = new MagnetRoyalities();
    }


}