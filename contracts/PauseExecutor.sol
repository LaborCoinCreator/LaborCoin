// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
interface ILaborToken {
function pause() external;
function unpause() external;
}
contract PauseExecutor {
address public dao;
address public laborToken;
modifier onlyDAO() {
require(msg.sender == dao, "Only DAO");
_;
}
constructor(address _dao, address _laborToken) {
require(_dao != address(0), "Invalid DAO");
require(_laborToken != address(0), "Invalid token");
dao = _dao;
laborToken = _laborToken;
}
function pause() external onlyDAO {
ILaborToken(laborToken).pause();
}
function unpause() external onlyDAO {
ILaborToken(laborToken).unpause();
}
}
