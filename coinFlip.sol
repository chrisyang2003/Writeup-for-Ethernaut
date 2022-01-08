// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract CoinFlip {

  using SafeMath for uint256;
  uint256 public consecutiveWins; //三个变量：连续赢
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() public { //public ?
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) { 
    /* 同样这里也是一个重点的地方
    分析：当前块的数量减一取哈希转为256无符号数
    */ 
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR); 
    /*/ 首先觉得这里可能有问题，但是使用了safemath可能有问题吗？
        分析div的含义：blockValue由于是取了哈希，分布在256位上，
        Factor是0x8000000000000000000000000000000000000000000000000000000000000000
        首位超过8是1，小于8是0
        我们知道以太坊确认时间大约是15s，那么我们是可以知道这个coinFlip值的
        那么方法可以是，利用attack合约调用实例合约自动攻击10次

    /*/ 
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
        // 如果猜对了次数加1
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}