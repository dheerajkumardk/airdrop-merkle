// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract ClaimAirdrop is Script {
    error ClaimAirdropScript__InvalidSignatureLength();

    address CLAIMING_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 CLAIM_AMOUNT = 25 ether;
    bytes32 pOne = 0xbaa072cd3aa185139d07facad6010bee6a3195bdf0bcaf20d16b94883a4b09a2;
    bytes32 pTwo = 0xa785c9730cd199c3ef8b27141d63009135c49f0c083e74fb1ffeb15b2a504de9;
    bytes32[] private proof = [pOne, pTwo];
    bytes private SIGNATURE =
        hex"897c479cde564f5afdc3cbd2f29eca27d2726ee5259c27d8583dbe434dc9eb81561ac6dc3a34290bb47ad44480e4a35dd5d25ad482030a3102366bf171ed87ec1c";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        claimAirdrop(mostRecentlyDeployed);
    }

    function claimAirdrop(address airdrop) public {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
        vm.startBroadcast();
        MerkleAirdrop(airdrop).claim(CLAIMING_ADDRESS, CLAIM_AMOUNT, proof, v, r, s);
        vm.stopBroadcast();
    }

    function splitSignature(bytes memory sig) public pure returns (uint8 v, bytes32 r, bytes32 s) {
        if (sig.length != 65) {
            revert ClaimAirdropScript__InvalidSignatureLength();
        }
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
