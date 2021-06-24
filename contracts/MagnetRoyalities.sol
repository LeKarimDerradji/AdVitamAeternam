//SPDX-License-Identifier: MIT


pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract MagnetRoyalities is AccessControl, ERC721 {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    using Counters for Counters.Counter;

    Counters.Counter private _copyrightId;

    struct Copyright {
        address author;
        bytes32 textHash;
        string name;
        string lastName;
        string certificateURI;
    }

    mapping(uint256 => Copyright) private _copyrights;

    constructor() ERC721("MagnetLicense","MAGL") {
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function authenticitate(address author, bytes32 textHash, string memory name, string memory lastName, string memory certificateURI) public onlyRole(MINTER_ROLE) returns(uint256) {
          uint256 tokenId = _copyrightId.current();
          _mint(author, tokenId);
          _copyrightId.increment();
          _copyrights[tokenId] = Copyright(author, textHash, name, lastName, certificateURI);
          return tokenId;
    }
}