// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import 'erc721a/contracts/ERC721A.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import './IncentiveToken.sol';

contract NFT721AToken is ERC721A, Ownable {
  uint256 MAX_MINTS = 50;
  uint256 MAX_SUPPLY = 4;
  uint256 public mintRate = 0.00002 ether;
  uint256 public whiteMintListPrice = 0.001 ether;
  uint256 public nonWhiteMintListPrice = 0.002 ether;
  IERC20 private _erc20Token;
  string public baseURI = 'ipfs://';
  uint256 whtMntPrs = 0.001 ether;
  uint256 nonWhtMntPrs = 0.05 ether;
  uint256 private s_lastTimeStamp;
  address[] private userAddress;
  uint256 private immutable i_interval;
  address payable l_incentiveTokenAddress;
  mapping(string => string) public uriToIpsfsUri;
  IncentiveToken public incentiveToken;

  constructor(uint256 interval) ERC721A('CalSoft', 'CS') {
    incentiveToken = new IncentiveToken();
    i_interval = interval;
    s_lastTimeStamp = block.timestamp;
  }

  using Strings for uint256;

  function createToken(string[] memory tokenURIInfo) public payable {
    uint256 quantity = tokenURIInfo.length;
    require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, 'Exceeded the limit');
    require(totalSupply() + quantity <= MAX_SUPPLY, 'Not enough tokens left');
    require(msg.value >= (mintRate * quantity), 'Not enough ether sent');
    _safeMint(msg.sender, quantity);
    userAddress.push(msg.sender);
    for (uint256 i = totalSupply() + 1; i <= totalSupply() + quantity; i++) {
      uriToIpsfsUri[tokenURI(i)] = tokenURIInfo[i];
    }
  }

  function withdraw() external payable onlyOwner {
    payable(owner()).transfer(address(this).balance);
  }

  function getIPFSURL(uint256 tokenId) public view returns (string memory) {
    return uriToIpsfsUri[string(abi.encodePacked(baseURI, tokenId.toString()))];
  }

  function _baseURI() internal view override returns (string memory) {
    return baseURI;
  }

  function setMintRate(uint256 _mintRate) public onlyOwner {
    mintRate = _mintRate;
  }

  function getWhiteListMinPrice() public view returns (uint256) {
    return whiteMintListPrice;
  }

  function getNonWhiteListMinPrice() public view returns (uint256) {
    return nonWhiteMintListPrice;
  }

  function checkUpkeep(
    bytes memory /* checkData */
  ) public view returns (bool upkeepNeeded, bytes memory /* performData */) {
    bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval);
    upkeepNeeded = (timePassed && userAddress.length > 0);
    return (upkeepNeeded, '0x0');
  }

  function performUpkeep(bytes calldata /* performData */) external {
    (bool upkeepNeeded, ) = checkUpkeep('');

    if (!upkeepNeeded) {
      uint256 amount = 10;
      incentiveToken.transfer(msg.sender, amount);
    }
  }
}
