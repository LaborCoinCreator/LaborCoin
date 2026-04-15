// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
interface ILaborVote {
function mint(address to) external;
}
contract LaborVoteMintExecutor {
address public dao;
address public laborVote;
modifier onlyDAO() {
require(msg.sender == dao, "Only DAO");
_;
}
constructor(address _dao, address _laborVote) {
require(_dao != address(0), "Invalid DAO");
require(_laborVote != address(0), "Invalid token");
dao = _dao;
laborVote = _laborVote;
}
function mint(address user) external onlyDAO {
ILaborVote(laborVote).mint(user);
}
}
