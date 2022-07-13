// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";



/// @title CryptoKart ERC1155 NFTs creation contract
/// @author METABRIDGE 
/// @notice  Creates CryptoKart ERC1155 NFTs 
/// @dev Creates ERC1155 NFTs inheriting openzeppelin libraries

contract CryptoKartNFTs is 
    ERC1155,
    Ownable,
    Pausable,
    ERC1155Burnable,
    ERC1155Supply
{

/// @notice Mapping of NFTs and their corresponding uris
/// @dev Using this map in order to keep track of the pair NFT-URI

    mapping(uint256 => string) private _uris;

// Testins NFTs to be removed before production
    uint256 public constant Kart1 = 1;
    uint256 public constant Kart2 = 2;
    uint256 public constant Kart3 = 3;

/// @notice Constructor to mint first NFTs if is needed
/// @dev Owner of this contract mints first NFTs


    constructor() ERC1155("https://test.ipfs.cryptokart.link/{id}.json") {
        _mint(msg.sender, Kart1, 10, "");
        _mint(msg.sender, Kart2, 20, "");
        _mint(msg.sender, Kart3, 30, "");
    }

/// @notice Fetch the uri of a given NFT 
/// @dev OVERRIDE uri function of openzeppelin
/// @param _nftId unsigned id number of the NFT


    function uri(uint256 _nftId) public view override returns (string memory) {
        return (_uris[_nftId]);
    }

/// @notice Set the uri for a given NFT
/// @dev Using the mapping _uris to keep track of NFTs and their corresponding uris
/// @param  _nftId unsigned Id of the NFT to set, 
/// @param  _uri string corresponding of the uri )


    function setNFTUri(uint256 _nftId, string memory _uri) public onlyOwner {
        require(bytes(_uris[_nftId]).length == 0, "Cannot set uri twice");
        _uris[_nftId] = _uri;
    }

/// @notice Triggers stopped state.
/// @dev Requirements: the contract must not be paused


    function pause() public onlyOwner {
        _pause();
    }


/// @notice Returns to normal state.
/// @dev  Requirements: the contract must be paused.


    function unpause() public onlyOwner {
        _unpause();
    }

    /// @notice Creates/mints token amount of NFT type id, and assigns them to account.
    /// @dev Emits a TransferSingle event. Requirements: account cannot be the zero address.
    /// If account refers to a smart contract, it must implement 
    /// IERC1155Receiver.onERC1155Received and return the acceptance magic value.
    /// @param _account address account to assign the NFT
    /// @param _id unsigned identifier of the NFT
    /// @param _amount unsigned amount of the NFT to be minted
    /// @param _data bytes data)
   
  
    function mint(
        address _account,
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) public onlyOwner {
        _mint(_account, _id, _amount, _data);
    }

    /// @notice Batched version of mint function.
    /// @dev  Requirements:ids and amounts must have the same length.
    /// If to refers to a smart contract, it must implement 
    /// IERC1155Receiver.onERC1155BatchReceived and return the acceptance magic value.
    /// @param _to address account to assign the NFT
    /// @param _ids unsigned identifiers array of the NFTs
    /// @param _amounts unsigned amounts array of the NFTs to be minted
    /// @param  _data bytes datas
   

    function mintBatch(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) public onlyOwner {
        _mintBatch(_to, _ids, _amounts, _data);
    }
    
    /// @dev Internal function 
  
    function _beforeTokenTransfer(
        address _operator,
        address _from,
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
        super._beforeTokenTransfer(
            _operator,
            _from,
            _to,
            _ids,
            _amounts,
            _data
        );
    }
}
