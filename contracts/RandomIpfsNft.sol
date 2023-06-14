// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//stating the erros now
error RandomIpfsNft__AlreadyInitialized();
error RandomIpfsNft__NeedMoreETHSent();
error RandomIpfsNft__RangeOutOfBounds();
error RandomIpfsNft__TransferFailed();

contract RandomIpfsNft is VRFConsumerBaseV2, ERC721 {
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
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane; //maximum gas price that the consumer contract is willing to pay for the callback transaction
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    //VRF Helpers
    mapping(uint256 => address) private requestIdToSender;

    //NFT variables
    uint256 private tokenCounter = 0;
    uint256 internal constant MAX_CHANCE_VALUE = 100;

    //Events
    event NftRequested(uint256 indexed requestId, address requester);
    event NftMinted(Breed breed, address minter);

    //what eactly is this address vrfCoordinatorV2
    constructor(
        address _vrfCoordinatorV2,
        uint64 _subscriptionId,
        bytes32 _gasLane, //gasLane is same as keyHash now
        uint32 _callbackGasLimit,
        uint256 _mintFee,
        string[3] memory _dogTokenUris
    ) VRFConsumerBaseV2(_vrfCoordinatorV2) ERC721("Random IPFS NFT", "RIN") {
        i_vrfCoordinator = VRFCoordinatorV2Interface(_vrfCoordinatorV2); //this is the vrf coordinator
        i_gasLane = _gasLane;
        i_subscriptionId = _subscriptionId;
        i_callbackGasLimit = _callbackGasLimit;
    }

    function requestNFT() public returns (uint256 requestId) {
        requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        requestIdToSender[requestId] = msg.sender;
        return requestId;
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        address dogOwner = requestIdToSender[requestId];
        uint256 newTokenId = tokenCounter++;
        _safeMint(dogOwner, newTokenId);
        //using the rare NFT function and random chainlink VRF to assign an image to this unique NFT
        uint256 moddedRng = randomWords[0] % MAX_CHANCE_VALUE; //moddedRng [0,99]
        //7 - PUG [0,10)
        //33 - SHIBA INU [10,40)
        //55 - ST. BERNARD [40,100]
    }

    //mapping moddedRNG to breed
    function getBreedFromModdedRng(
        uint256 moddedRng
    ) public pure returns (Breed breed) {
        uint256 cumulativeSum = 0;
        uint256[3] memory chanceArray = getChanceArray();
        for (uint256 i = 0; i < chanceArray.length; i++) {
            // Pug = 0 - 9  (10%)
            // Shiba-inu = 10 - 39  (30%)
            // St. Bernard = 40 = 99 (60%)
            if (moddedRng >= cumulativeSum && moddedRng < chanceArray[i]) {
                return Breed(i);
            }
            cumulativeSum = chanceArray[i];
        }
        revert RandomIpfsNft__RangeOutOfBounds();
    }

    //function to implement the rarity of docs
    function getChanceArray() public pure returns (uint256[3] memory) {
        return [10, 40, MAX_CHANCE_VALUE];
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {}
}
