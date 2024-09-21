// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {ArtihcToken} from "../src/ArtihcToken.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {DeployAirdrop} from "../script/DeployAirdrop.s.sol";

contract MerkleAirdropTest is Test {
    ArtihcToken public artihc;
    MerkleAirdrop public airdrop;
    bytes32 public ROOT = 0xbc86e6904fe9bb5c8709a9d4af93060f21ce2a743c328bfdbeb644ff3a8a7a03;
    bytes32[] public PROOF = [
        bytes32(0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a),
        bytes32(0xa785c9730cd199c3ef8b27141d63009135c49f0c083e74fb1ffeb15b2a504de9)
    ];
    address alice;
    uint256 alicePvtKey;
    address aliceKaPA;

    uint256 CLAIM_AMOUNT = 25 ether;
    uint256 TOTAL_AIRDROP_AMOUNT = 4 * CLAIM_AMOUNT;

    function setUp() public {
        DeployAirdrop deployer = new DeployAirdrop();
        (artihc, airdrop) = deployer.run();

        (alice, alicePvtKey) = makeAddrAndKey("alice");
        aliceKaPA = makeAddr("alice ka PA");
        console.log(alicePvtKey);
    }

    function testUserCanClaim() public {
        uint256 startingBal = artihc.balanceOf(alice);

        bytes32 message = airdrop.getMessageHash(alice, CLAIM_AMOUNT);

        // sign the txn using alice pvt key
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(alicePvtKey, message);

        vm.prank(aliceKaPA);
        airdrop.claim(alice, CLAIM_AMOUNT, PROOF, v, r, s);

        uint256 endingBal = artihc.balanceOf(alice);

        assertEq(endingBal, startingBal + CLAIM_AMOUNT);
    }
}
