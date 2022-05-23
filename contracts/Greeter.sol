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
        uint levelApp;
        uint mined;
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

    function createPrt(string memory _name, uint _Enimaltype) external payable onlyOwner{

        uint cPriceForEat = 200000;
        require(msg.value == cPriceForEat, "Not enougt funds!");


        MyPet memory newPet = MyPet({
            name: _name,
            Enimaltype: _Enimaltype,
            level: randMod10(),
            hungry: randMod100(),
            profit: randMod100(),
            levelApp: 0,
            mined: 0
        });
        emit addPet(_name, _Enimaltype, randMod10(), randMod100(), randMod100());

        myPets.push(newPet);
    }

    function eat(uint _index) external payable {
        MyPet storage cMyPets = myPets[_index];
        uint cPriceForEat = 2000;
        require(cMyPets.hungry < 100, "Already eaten!");
        require(msg.value == cPriceForEat, "Not enougt funds!");
        cMyPets.hungry = 100;

        emit Eat("Eaten");
    }
    function create(uint _index) external {
        MyPet storage cMyPets = myPets[_index];
        require(cMyPets.hungry >= 25, "Need to be fed!");
        cMyPets.hungry = cMyPets.hungry - 25;
        cMyPets.levelApp = cMyPets.levelApp + 1;
        if(cMyPets.levelApp >= 5){
            cMyPets.level = cMyPets.level + 1;
            cMyPets.levelApp = 0;
        }

        cMyPets.mined = cMyPets.mined + randMod10();

        emit Work("Worked");
    }

    function balance() external view returns(uint){
        return address(this).balance;
    }

    function withdraw(address _addr, uint _index) external {
        MyPet storage cMyPets = myPets[_index];
        require(cMyPets.mined > 0, "Not enough funds!");
        uint ammount = cMyPets.mined;
        payable(_addr).transfer(ammount);
        cMyPets.mined = 0;
    }
    // 0x976EA74026E726554dB657fA54763abd0C3a0aa9
}