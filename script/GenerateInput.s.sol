// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";

contract GenerateInput is Script {
    uint256 amount = 25 ether;
    string[] types = new string[](2);
    uint256 count;
    string[] whitelisted = new string[](4);
    string private inputPath = "/script/target/input.json";

    function run() public {
        types[0] = "address";
        types[1] = "uint";
        whitelisted[0] = "0x328809Bc894f92807417D2dAD6b7C998c1aFdac6";
        whitelisted[1] = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
        whitelisted[2] = "0xea475d60c118d7058beF4bDd9c32bA51139a74e0";
        whitelisted[3] = "0x7E09429585169ABA1759346eb6b94C91f3C7203b";
        count = whitelisted.length;
        string memory input = _createJSON();
        // writing output file
        vm.writeFile(string.concat(vm.projectRoot(), inputPath), input);

        console.log("DONE: The output file is at %s", inputPath);
    }

    function _createJSON() internal view returns (string memory) {
        string memory countString = vm.toString(count);
        string memory amountString = vm.toString(amount);
        string memory json = string.concat('{ "types": ["address", "uint"], "count":', countString, ',"values":{');

        for (uint256 i = 0; i < whitelisted.length; i++) {
            if (i == whitelisted.length - 1) {
                json = string.concat(
                    json,
                    '"',
                    vm.toString(i),
                    '"',
                    ': { "0":',
                    '"',
                    whitelisted[i],
                    '"',
                    ', "1":',
                    '"',
                    amountString,
                    '"',
                    " }"
                );
            } else {
                json = string.concat(
                    json,
                    '"',
                    vm.toString(i),
                    '"',
                    ': { "0":',
                    '"',
                    whitelisted[i],
                    '"',
                    ', "1":',
                    '"',
                    amountString,
                    '"',
                    " },"
                );
            }
        }

        json = string.concat(json, "} }");
        return json;
    }
}
