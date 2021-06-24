//SPDX-License-Identifier: MIT


pragma solidity ^0.8.5;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AuthorLicense is AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    using Counters for Counters.Counter;

    struct LicenseMetadata {
        bytes32 textHash;
        address author;
        string liceseURI;
    }

    

    constructor(bytes32 textHash, address author, string memory licenseURI) {
        _setupRole(MINTER_ROLE, msg.sender);
    }
}