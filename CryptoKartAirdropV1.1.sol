//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


interface IERC1155{
     function safeTransferFrom( address from, address to, uint256 id, uint256 amount, bytes calldata data ) external;
}

/// @title CryptoKart bulk NFTs Airdrop contract
/// @author METABRIDGE
/// @notice Airdrops CryptoKart ERC1155 NFTs to a selected users
/// @dev Inherits IERC1155 safeTransferFrom function and the contract is allowed to receive ERC1155 tokens 
contract CryptoKartAirDrop is ERC1155Holder, Ownable{
  
  /// @notice Uses to keep track of the info of the user airdrop. 
  /// @dev Basic type struct to keep track of the airdrop's user info
 
    struct Airdrop{
        uint nftId;
        uint amount;
        IERC1155 nft;
        
    }

    /// @notice Keeps track of the airdrop related to the receiving user/address
    /// @dev Basic mapping to keep track of the airdrop, receiving addresss => all airdrop info Airdrop

    mapping (address => Airdrop) public airdrops;
 
    constructor(){}

    /// @notice Bulks airdrop the NFts to the receiving users/addresses
    /// @dev Using inherited safeTransferFrom() function to airdrop the NFTs 
    /// @param _nft is the IERC1155  to be airdroped 
    /// @param _to are the receiving users/addresses of the airdrop
    /// @param _id are the unsigned ids of the NFTs of the airdrops
    /// @param _amount are the amount of NFT corresponding to each Id to be airdroped 
   

      function airDropERC1155(IERC1155 _nft, address[] calldata _to,uint256[] calldata _id, uint256[] calldata _amount) public onlyOwner {
        
        require(_to.length == _id.length,"Receiver and ids are differents lengths" );
        for (uint i = 0; i < _to.length; i++){
            airdrops[_to[i]].nft =_nft;
            airdrops[_to[i]].nftId = _id[i];
            airdrops[_to[i]].amount = _amount[i];    
            _nft.safeTransferFrom(address(this), _to[i],_id[i],_amount[i],"");
        }
    }

}
