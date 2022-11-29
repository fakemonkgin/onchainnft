// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Base.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


contract Contract is ERC721Base {

      constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    )
        ERC721Base(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps
        )
    {}

    string[] public characters = ["Lan", "BigS", "SmallS", "Fei", "Tutou"];
    string[] public props = ["egg", "greentea", "jeans&bags", "electricitybill", "matress"];
    string[] public signs = ["Cancer", "Libra", "Gemini", "Aries", "Virgo"];

    function random(string memory _input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_input)));
    }

    function pluck(uint256 _tokenId, string memory _keyPrefix, string[] memory _sourceArray) internal pure returns(string memory) {
        uint256 randomNumber = random(string(abi.encodePacked(_keyPrefix, Strings.toString(_tokenId))));
        string memory output = _sourceArray[randomNumber % _sourceArray.length];
        return output;
    }

    function tokenURI(uint256 _tokenId) public view override returns(string memory) {
        string[7] memory parts;
 
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
    
        parts[1] = getCharacter(_tokenId);
    
        parts[2] = '</text><text x="10" y="40" class="base">';
    
        parts[3] = getProp(_tokenId);
    
        parts[4] = '</text><text x="10" y="60" class="base">';
    
        parts[5] = getSign(_tokenId);

        parts[6] = '</text><text x="10" y="40" class="base">';
    
        parts[7] = '</text></svg>';
    
        string memory output =
            string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7]));
    
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Show Card: ', Strings.toString(_tokenId), '", "description": "Something happened lately!", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        
        output = string(abi.encodePacked('data:application/json;base64,', json));
        
        return output;
    }

    function getCharacter(uint256 _tokenId) public view returns(string memory) {
        return pluck(_tokenId, "CHARACTER", characters);
    }
    
     function getProp(uint256 _tokenId) public view returns(string memory) {
        return pluck(_tokenId, "PROP", props);
    }

     function getSign(uint256 _tokenId) public view returns(string memory) {
        return pluck(_tokenId, "SIGN", signs);
    }

    function claim(uint256 _amount) public {
        require(_amount > 0 && _amount < 6);
        _safeMint(msg.sender, _amount);
    }

}