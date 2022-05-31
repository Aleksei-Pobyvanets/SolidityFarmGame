//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract salary {
    address owner = msg.sender;

    struct Sal {
        string workerName;
        address payable worker;
        uint salForHour;
        uint workedHours;
        bool doneSalary;
        uint timeLastSalary;
    }

    Sal[] public sals;

    event AddWorker(string workerName, address worker, uint salForHour, uint workedHours, uint timeLastSalary);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not an owner");
        _;
    }


// Принимает переменные и записывает их
    function createWorkersSal(string memory _workerName, uint _salForHour, address payable _worker, uint _workedHours) external onlyOwner{
        require(_salForHour > 0, "Invalid salary");
        require(_workedHours > 0, "Invalid worked hours");

        Sal memory newWorkerSal = Sal({
            workerName: _workerName,
            worker: _worker,
            salForHour: _salForHour,
            workedHours: _workedHours,
            doneSalary: false,
            timeLastSalary: block.timestamp
        });


// пушит новый элемент в массив
        sals.push(newWorkerSal);
    }


// Эта функция создана для того, что бы оплатить ЗП всем работникам.
    function paySal() public payable onlyOwner{
        uint calculatedSal;
        
        for(uint i = 0; i < sals.length; i++){
            if(sals[i].doneSalary != true){
                sals[i].worker.transfer(sals[i].salForHour * sals[i].workedHours);
                sals[i].doneSalary = true;
                sals[i].timeLastSalary = block.timestamp;
            }
        }
    }

}