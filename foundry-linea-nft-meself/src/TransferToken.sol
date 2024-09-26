// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SignatureVerifier} from "./SignatureVerifier.sol";

contract TransferToken is Ownable {
    IERC20 private token; //ERC20代币接口
    SignatureVerifier private verifier; //验证合约

    constructor(
        address tokenAddress,
        address verifierAddress
    ) Ownable(msg.sender) {
        verifier = SignatureVerifier(verifierAddress);
        token = IERC20(tokenAddress);
    }

    function transferWithSignature(
        uint amount,
        bytes memory signature,
        address messageTo
    ) external {
        require(
            verifier.verifySignature(signature, messageTo),
            "Invalid signature"
        );
        require(messageTo != address(0), "Invalid address");
        require(token.transfer(messageTo, amount), "Transfer falied");
    }

    function updateVerifier(address newVerifier) external onlyOwner {
        verifier = SignatureVerifier(newVerifier);
    }

    function updateToken(address newToken) external onlyOwner {
        token = IERC20(newToken);
    }
}
