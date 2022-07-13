//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


interface IERC1155{
     function safeTransferFrom( address from, address to, uint256 id, uint256 amount, bytes calldata data ) external;
}

/// @title CryptoKart NFTs Airdrop contract. 
/// @author METABRIDGE
/// @notice Airdrops CryptoKart ERC1155 NFTs to a selected users. Adds functionality to add or delete receivers. 
////@notice Receivers users/addresses can claim their NFTs 
/// @dev Inherits IERC1155 safeTransferFrom function and the contract is allowed to receive ERC1155 tokens 


contract CKAirdrop is ERC1155Holder, Ownable{
    

 /// @notice Uses to keep track of the info of the receiving user airdrop. 
 /// @dev Basic type struct to keep track of the airdrop's receiving user info

    struct Airdrop{
        address nft;
        uint id; 
        uint amount; 
        address receiver;
    }

 /// @notice Keeps track of the airdrop related to the receiving user/address
 /// @dev Basic mapping to keep track of the airdrop, receiving addresss => all airdrop info Airdrop
   
    mapping (address => Airdrop) public airdrops;

/// @notice Keeps track if the recepient/receiver is allowed to receive the airdrop
/// @dev Basic mapping to keep track of recepient/receiver => allowed (bool true/false) to receive the airdrop

    mapping (address => bool) public recipients;

    constructor(){}

/// @notice Transfers the airdrop to the contract. 
/// @dev Using inherited safeTransferFrom() function to airdrop the NFTs to this contract and set the airdrop's users/receivers info to the
/// mapping address => Airdrop to then, allow the users/receivers to claim their NFTs 
/// @param _airdrops array of Airdrop's with the users/receivers airdrop info
   
      function setAirDrops(Airdrop[] memory _airdrops) external onlyOwner{
        
          for (uint i = 0; i < _airdrops.length; i++){   
              address receiver = address(_airdrops[i].receiver);
              airdrops[receiver].receiver = receiver;
              airdrops[receiver].nft = _airdrops[i].nft;
              airdrops[receiver].id = _airdrops[i].id;
              airdrops[receiver].amount = _airdrops[i].amount;
              IERC1155(_airdrops[i].nft).safeTransferFrom(msg.sender,address(this),_airdrops[i].id,_airdrops[i].amount,"");
     
          }
      }
/// @notice Add new receivers/recipients to the airdrop. 
/// @param _recipients array of new receivers/recipients to be added to the original airdrop


      function addRecipients(address[] memory _recipients) external onlyOwner{
          for (uint i = 0; i < _recipients.length; i++){
              recipients[_recipients[i]] = true;
          }
      }

/// @notice Delete receivers/recipients to the airdrop. 
/// @param _recipients array of new receivers/recipients to be deleted from the airdrop


        function removeRecipients(address[] memory _recipients) external onlyOwner{
       
            for (uint i = 0; i < _recipients.length; i++){
              recipients[_recipients[i]] = false;
            }
        }

/// @notice Receiver/recipient claims his airdrop from the contract
/// @dev Using inherited safeTransferFrom() function to airdrop the NFTs from this contract to a valid/registered, receiver/recipient user

        function claim() external{
            require (recipients[msg.sender] == true,"recipient not registered");
            recipients[msg.sender] = false;
            Airdrop storage airdrop = airdrops[msg.sender];
            IERC1155(airdrop.nft).safeTransferFrom(address(this),msg.sender,airdrop.id,airdrop.amount,"");
            
        }

}
