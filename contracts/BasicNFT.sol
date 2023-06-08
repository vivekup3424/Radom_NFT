// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    uint256 private s_TokenCounter = 0;
    string public constant TOKEN_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json"; //this will return the metadata containing the url of the image

    constructor() ERC721("Doggie", "DOG") {
        s_TokenCounter = 0;
    }

    /**
     * @notice This function generates new doggie nft.
     * @dev This transfer the token with unique ID to the message.sender
     * @return An integer counter
     */
    function mintNFT() public returns (uint256) {
        _safeMint(msg.sender, s_TokenCounter);
        s_TokenCounter++;
        return s_TokenCounter;
    }

    //an read/view function
    function getTokenCounter() public view returns (uint256) {
        return s_TokenCounter;
    }

    /**
     * @notice We are using the override keyword beacause we are explicitly overriding this function from the
     * ERC721.sol contract
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(
        uint256 /*tokenId*/
    ) public view override returns (string memory) {
        return TOKEN_URI;
    }
}
