//SPDX-License-Identifier: MIT


pragma solidity ^0.8.5;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./Aeternam.sol";


contract AdVitamAeternam is Ownable {

    using Address for address payable;

    event ProfitWithdrewed(address indexed account, uint256 amount);
    event Authentification(address indexed account, string name, string lastName);
    event TokenListed(address indexed account, uint256 tokenID, uint256 price);

    mapping(uint256 => uint256) private _tokenPrice;
    
    Aeternam private _aeternam;

    constructor() {
        _aeternam = new Aeternam();
    }

    function immortalize(
        bytes32 textHash, 
        address author, 
        string memory content,
        string memory name, 
        string memory lastName,
        string memory uri) 
        public payable {
        _aeternam.immortalize(textHash, author, content, name, lastName, uri);
        emit Authentification(msg.sender, name, lastName);
    }

    function listToken(uint256 tokenId, uint256 price) public {
        require(_aeternam.ownerOf(tokenId) == msg.sender, "AdVitamAeternam: You do not own that token");
        _tokenPrice[tokenId] = price;
        _aeternam.approve(address(this), tokenId);
        emit TokenListed(msg.sender, tokenId, price);
    }

    function buyToken(uint256 tokenId) public payable {
        require(msg.value >= _tokenPrice[tokenId], "AdVitamAeternam: You need to send more eth to get that one");
        payable(_aeternam.ownerOf(tokenId)).sendValue(msg.value);
        _aeternam.transferFrom(_aeternam.ownerOf(tokenId), msg.sender, tokenId);
    }

    function withdrawProfit() public payable onlyOwner() {
        require(address(this).balance > 0, "AdVitamAeternam: there is nothing to withdraw here!");
        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(address(this).balance);
        emit ProfitWithdrewed(msg.sender, amount);
    }

    function profit() public view onlyOwner() returns(uint256)  {
        return address(this).balance;
    }

    function getPrice(uint256 tokenId) public view returns(uint256) {
        return _tokenPrice[tokenId];
    }

    function aeternam() public view returns(address) {
        return address(_aeternam);
    }

}

