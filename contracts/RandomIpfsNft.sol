// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RandomIpfs is VRFConsumerBaseV2{
    //when we mint an NFT, we will get a random number 
    //using that random number, we will get an random NFT
    //users have to pay to mint nft
    //the owner of the contract can withdraw the NFT

    function requestNFT() public {}
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal {}
    fuction tokenURI(uint256) public {}
}
