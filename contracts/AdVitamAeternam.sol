//SPDX-License-Identifier: MIT


pragma solidity ^0.8.5;

// Import Address for Address Payable, the function that will mint a contract will be payable, 
// See KingOfTheHill for that

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./Aeternam.sol";

// Un rôle pour les poètes, un rôle pour l'owner, un rôle pour celui qui vérifie 


contract AdVitamAeternam is Ownable {

    using Address for address payable;

    event ProfitWithdrewed(address indexed account, uint256 amount);
    event Authentification(address indexed account, string name, string lastName, string certificateURI);
    
    Aeternam private _aeternam;

    constructor() {
        _aeternam = new Aeternam();
    }

    function immortalize(
        bytes32 textHash, 
        address author, 
        string memory name, 
        string memory lastName, 
        string memory certificateURI) 
        public payable {
        require(msg.value > (1 ether / 2), "AdVitamAeternam: you need to send 1 ether to use that function");
        _aeternam.immortalize(textHash, author, name, lastName, certificateURI);
        emit Authentification(msg.sender, name, lastName, certificateURI);
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

    function aeternam() public view returns(address) {
        return address(_aeternam);
    }

}

