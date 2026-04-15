// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract TreasuryExecutor {
address public dao;
modifier onlyDAO() {
require(msg.sender == dao, "Only DAO");
_;
}
constructor(address _dao) {
require(_dao != address(0), "Invalid DAO");
dao = _dao;
}
function sendETH(address payable to, uint256 amount) external onlyDAO {
require(to != address(0), "Invalid address");
require(address(this).balance >= amount, "Insufficient balance");
(bool success, ) = to.call{value: amount}("");
require(success, "Transfer failed");
}
receive() external payable {}
}
