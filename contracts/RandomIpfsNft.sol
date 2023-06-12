// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

//stating the erros now
error RandomIpfsNft__AlreadyInitialized();
error RandomIpfsNft__NeedMoreETHSent();
error RandomIpfsNft__RangeOutOfBounds();
error RandomIpfsNft__TransferFailed();

contract RandomIpfsNft is VRFConsumerBaseV2 {
    //when we mint an NFT, we will get a random number
    //using that random number, we will get an random NFT
    //users have to pay to mint nft
    //the owner of the contract can withdraw the NFT

    //Types
    enum Breed {
        PUG,
        SHIBA_INU,
        ST_BERNARD
    }
    //chainlink vrf variables
    VRFCoordinatorV2Interface immutable private i_vrfCoordinator;
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS=3;
    uint32 private constant NUM_WORDS = 1;

    //what eactly is this address vrfCoordinatorV2
    constructor(address _vrfCoordinatorV2) VRFConsumerBaseV2(_vrfCoordinatorV2) 
    {
        i_vrfCoordinator = new VRFCoordinatorV2Interface(_vrfCoordinatorV2); //this is the vrf coordinator
    }
    function requestNFT() public {}

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {;}

    function tokenURI(uint256) public {;}
}
