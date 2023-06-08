// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    uint256 private s_TokenCounter = 0;

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
}
