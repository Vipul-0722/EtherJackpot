// SPDX-License-Identifier: GPL-3.0 

pragma solidity >=0.7.0 <0.9.0; 


contract Lottery {
    
    address public manager;                // manage all the lottery
    address payable[] public participants;  // array becz many participant are there payable we want to give ether to winner 
    // when ever we want to tranfer some ether to some account then we need to make that account payable
    
    constructor()
    {
        // manager will have all rights of this contract 
        // there he will deploy the contract
        manager=msg.sender;  // this will assign address of deployer's account
    }

    // receive is inbuild function only 1 time declared in whole contract
    // it is used with external
    
    receive() external payable
    {
        // require act as if and else
       require(msg.value==1 ether);    // if this is true then only below command will work
       participants.push(payable(msg.sender));  // push address of the sender
    }
  
    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager); // manager only get access to the balance
        return address(this).balance;
    }
    
    // dont actually use in smart contract

    function random() public view returns(uint){
        // random function below random generation method
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public {
       require(msg.sender==manager); 
       require(participants.length>=3);
       uint r=random();
       // remainder will be always less than players.length;
       address payable winner;
       uint index= r % participants.length;
       winner=participants[index];
       winner.transfer(getBalance());

       // making zero size 
       participants=new address payable[](0);

        
    }
}