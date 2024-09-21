// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {ArtihcToken} from "../src/ArtihcToken.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract DeployAirdrop is Script {
    bytes32 private s_merkleRoot = 0xbc86e6904fe9bb5c8709a9d4af93060f21ce2a743c328bfdbeb644ff3a8a7a03;
    uint256 private s_totalAirdropAmount = 100 ether;

    function run() external returns (ArtihcToken, MerkleAirdrop) {
        vm.startBroadcast();
        ArtihcToken artihc = new ArtihcToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(s_merkleRoot, address(artihc));
        artihc.mint(address(airdrop), s_totalAirdropAmount);
        vm.stopBroadcast();

        return (artihc, airdrop);
    }
}
