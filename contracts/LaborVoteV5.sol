// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
contract LaborVoteV5 is ERC20Votes {
address public dao;
address public minter;
bool public minterLocked;
modifier onlyDAO() {
require(msg.sender == dao, "Only DAO");
_;
}
modifier onlyMinter() {
require(msg.sender == minter, "Not authorized");
_;
}
constructor(address _dao)
ERC20("LaborVote", "LABRV")
EIP712("LaborVote", "1")
{
require(_dao != address(0), "Invalid DAO");
dao = _dao;
minter = _dao;
}
// --- MINT (1 full token per wallet) ---
function mint(address to) external onlyMinter {
require(to != address(0), "Invalid address");
require(balanceOf(to) == 0, "Already registered");
_mint(to, 1 ether); // ✅ FIXED (1 full token)
}
// --- BOOTSTRAP + DAO CONTROL ---
function setMinter(address _minter) external {

require(!minterLocked, "Minter locked");
require(
msg.sender == dao || msg.sender == tx.origin,
"Not authorized"
);
require(_minter != address(0), "Invalid address");
minter = _minter;
}
function lockMinter() external {
require(
msg.sender == dao || msg.sender == tx.origin,
"Not authorized"
);
minterLocked = true;
}
// --- SOULBOUND ---
function _update(address from, address to, uint256 value)
internal
override
{
if (from != address(0) && to != address(0)) {
revert("Non-transferable");
}
super._update(from, to, value);
}
}
