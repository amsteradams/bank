// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

contract bank is Ownable{

    /*address public owner;*/
    uint public timeStamp; //Used to store timeStamp of the first deposit
    uint public counterDeposit; //deposit id's
    uint public counterWithdraw; //withdraw id's

    mapping(uint /*0 for deposit, 1 for withdraw*/ => mapping (uint => uint)) Log; //log of transactions
    
    /*
    constructor(){
        //owner = msg.sender;
    }
    
    modifier isOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }
    */
    /*
        first, it checks if 3 months passed since the first deposit
        then the function send the _amount, it write transaction in the log mapping and increment the Withdraw counter
    */
    function withdraw(uint _amount)public payable onlyOwner /*isOwner*/ {
        require((timeStamp + 12 weeks) <= block.timestamp, "Sorry, not yet !");
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");
        Log[1][counterWithdraw] = _amount;
        counterWithdraw += 1;
    }

    /*
        If it's the first transac, save the current timestamp
        then write the transaction and increment deposit counter
    */
    receive()external payable{
        if(counterDeposit == 0){
            timeStamp = block.timestamp;
        }
        Log[0][counterDeposit] = msg.value;
        counterDeposit += 1;
    }

    /*
        find a transaction
    */
    function getTransac(uint operation,uint id)public view returns(uint){
        return Log[operation][id];
    }
    /*
        get contract's balance
    */
    function getBalance()public view returns(uint){
        return address(this).balance;
    }
}