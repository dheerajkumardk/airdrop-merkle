// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import {MerkleProof} from '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';

contract MerkleAirdrop {
    using SafeERC20 for IERC20;
    
    error MerkleAirdrop__InvalidProof();

    // some list of whitelisted addresses
    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address user => bool claimed) private s_hasClaimed;

    event AirdropClaimed(address indexed account, uint256 amount);

    constructor(bytes32 merkleRoot, address aidropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = IERC20(aidropToken);
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        // leaf node <-- from account and amount
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));

        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        s_hasClaimed[account] = true;
        emit AirdropClaimed(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }
    
    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }
}
