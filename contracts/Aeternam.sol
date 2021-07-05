//SPDX-License-Identifier: MIT


pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Aeternam is AccessControl, ERC721Enumerable, ERC721URIStorage {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    using Counters for Counters.Counter;

    Counters.Counter private _tokenId;

    struct TokenContent {
        bytes32 textHash;
        address author;
        string content;
        string name;
        string lastName;
    }

    mapping(uint256 => TokenContent) private _tokenContent;

    constructor() ERC721("Aeternam","AETER") {
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function immortalize(
        bytes32 textHash,
        address author, 
        string memory content, 
        string memory name, 
        string memory lastName,
        string memory uri) public onlyRole(MINTER_ROLE)
            returns(uint256) {
               _tokenId.increment();
               uint256 currentId = _tokenId.current();
              _mint(author, currentId);
              _setTokenURI(currentId, uri);
              _tokenContent[currentId] = TokenContent(textHash, author, content, name, lastName);
              return currentId;
    }

    function aeternamById(uint256 id) public view returns(TokenContent memory) {
        return _tokenContent[id];
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721URIStorage, ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // Modifions _baseURI afin de retourner l'url de base
    // Cette fonction est utilisée par tokenURI pour retourner une url complète.
    // En fonction de l'item id (et pas du NFT id), nous aurons une url pour chacun de nos loots
    function _baseURI() internal view virtual override(ERC721) returns (string memory) {
        return "ipfs://";
    }

     // Il existe 2 définitions de _beforeTokenTransfer, il faut aider le compilateur à gérer ce conflit.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )  internal virtual override(ERC721Enumerable, ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Il existe 2 définitions de _burn il faut aider le compilateur à gérer ce conflit.
    function _burn(uint256 tokenId) internal virtual override(ERC721URIStorage, ERC721) {
        super._burn(tokenId);
    }

}