//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract MyFarm{
    address owner = msg.sender;

    struct MyPet {
        string name;
        uint Enimaltype;
        uint level;
        uint hungry;
        uint profit;
    }

    MyPet[] public myPets;

    event addPet(string name, uint Enimaltype, uint level, uint hungry, uint profit);
    event Eat(string);
    event Work(string);

    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(owner == msg.sender, "Not an owner");
        _;
    }

    uint randNonce = 0;
    function randMod10() internal returns(uint){
        randNonce++; 
        return uint(keccak256(abi.encodePacked(msg.sender,randNonce))) % 10;
    }
    function randMod100() internal returns(uint){
        randNonce++; 
        return uint(keccak256(abi.encodePacked(msg.sender,randNonce))) % 100;
    }

    function createPrt(string memory _name, uint _Enimaltype) external onlyOwner{

        MyPet memory newPet = MyPet({
            name: _name,
            Enimaltype: _Enimaltype,
            level: randMod10(),
            hungry: randMod100(),
            profit: randMod100()
        });
        emit addPet(_name, _Enimaltype, randMod10(), randMod100(), randMod100());

        myPets.push(newPet);
    }

    function eat(uint _index) external payable {
        MyPet storage cMyPets = myPets[_index];
        uint cPriceForEat = 2;
        require(cMyPets.hungry < 100, "Already eaten!");
        require(msg.value == cPriceForEat, "Not enougt funds!");
        cMyPets.hungry = 100;

        emit Eat("Eaten");
    }
    function create(uint _index) external {
        MyPet storage cMyPets = myPets[_index];
        require(cMyPets.hungry >= 25, "Need to be fed!");
        cMyPets.hungry = cMyPets.hungry - 25;

        emit Work("Worked");
    }

}
