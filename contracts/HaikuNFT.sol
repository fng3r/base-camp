// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title HaikuNFT
 */
contract HaikuNFT is ERC721 {
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    uint256 public counter = 1;

    Haiku[] public haikus;

    mapping(address => uint256[]) public sharedHaikus;

    mapping(string => bool) private linesUsed;

    error HaikuNotUnique();

    error NotYourHaiku(uint256 _id);

    error NoHaikusShared();

    constructor() ERC721("Haiku", "HAIKU") {}

    function mintHaiku(string memory _line1, string memory _line2, string memory _line3) external {
        if (linesUsed[_line1] || linesUsed[_line2] || linesUsed[_line3]) {
            revert HaikuNotUnique();
        }
        
        _safeMint(msg.sender, counter++);
        Haiku memory haiku = Haiku(msg.sender, _line1, _line2, _line3);
        haikus.push(haiku);
        linesUsed[_line1] = true;
        linesUsed[_line2] = true;
        linesUsed[_line3] = true;
    }

    function shareHaiku(address _to, uint256 _id) public {
        if (haikus[_id].author != msg.sender) {
            revert NotYourHaiku(_id);
        }

        sharedHaikus[_to].push(_id);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256 sharedCount = sharedHaikus[msg.sender].length;
        if (sharedCount == 0) {
            revert NoHaikusShared();
        }

        uint256[] memory sharedHaikuIds = sharedHaikus[msg.sender];
        Haiku[] memory _sharedHaikus = new Haiku[](sharedCount);
        for (uint256 i = 0; i < sharedCount; i++) {
            _sharedHaikus[i] = haikus[sharedHaikuIds[i]];
        }

        return _sharedHaikus;
    }
}