//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract IncentiveToken is ERC20 {
  constructor() ERC20('Incentive', 'RT') {
    _mint(msg.sender, 1000000 * 10 ** 18);
  }
}
