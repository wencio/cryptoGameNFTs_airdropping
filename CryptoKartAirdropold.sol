//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";



interface IERC20{
    function transferFrom( address from,  address to,  uint256 amount ) external returns (bool);
}   

interface IERC721 {
     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;   
}

interface IERC1155{
     function safeTransferFrom( address from, address to, uint256 id, uint256 amount, bytes calldata data ) external;
}

contract CryptoKartAirDrop is ERC1155Holder{
    address public owner;
    constructor(){
        owner = msg.sender;

    }

    function airDropERC20(IERC20 _token, address[] calldata _to,uint256[] calldata _values) public {
        require(owner == msg.sender, " Only owner can airdrop");
        require(_to.length == _values.length,"Receiver and amounts are differents lengths" );
        for (uint i = 0; i < _to.length; i++){
           require( _token.transferFrom(address(this), _to[i],_values[i]));
        }
    }

     function airDropERC721(IERC721 _token, address[] calldata _to,uint256[] calldata _id) public {
        require(owner == msg.sender, " Only owner can airdrop");
        require(_to.length == _id.length,"Receiver and ids are differents lengths" );
        for (uint i = 0; i < _to.length; i++){
            _token.safeTransferFrom(address(this), _to[i],_id[i],"");
        }
    }

      function airDropERC1155(IERC1155 _token, address[] calldata _to,uint256[] calldata _id, uint256[] calldata _amount) public {
        require(owner == msg.sender, " Only owner can airdrop");
        require(_to.length == _id.length,"Receiver and ids are differents lengths" );
        for (uint i = 0; i < _to.length; i++){
            _token.safeTransferFrom(address(this), _to[i],_id[i],_amount[i],"");
        }
    }

}
