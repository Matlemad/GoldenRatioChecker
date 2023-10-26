// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Minimal ERC-20 interface to fetch balances
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract GoldenRatioChecker {

    // Define the constant for the Golden Ratio
    uint256 private constant PHI_PRECISION = 10000;  // Using precision to 4 decimal places
    uint256 private constant PHI_VALUE = 16180;  // Represents 1.6180 (Golden Ratio to 4 decimal places)

    // Mapping to store scores for each address
    mapping(address => uint256) public scores;

    // Check the Golden Ratio balance between two given assets for a given address and update the score
    function checkGoldenRatio(address caller, address assetOne, address assetTwo) external returns (uint256) {
        // Fetch balances of the two assets for the given address
        uint256 balanceOne = IERC20(assetOne).balanceOf(caller);
        uint256 balanceTwo = IERC20(assetTwo).balanceOf(caller);

        require(balanceTwo != 0, "Asset2 balance should not be zero");  // Prevent division by zero

        // Calculate the ratio with precision
        uint256 currentRatio = (balanceOne * PHI_PRECISION) / balanceTwo;

        // Determine how far the current ratio is from the Golden Ratio
        uint256 deviation;
        if (currentRatio > PHI_VALUE) {
            deviation = currentRatio - PHI_VALUE;
        } else {
            deviation = PHI_VALUE - currentRatio;
        }

        // Add the deviation to the caller's score
        scores[caller] += deviation;

        // Return the total score for the caller
        return scores[caller];
    }
}
