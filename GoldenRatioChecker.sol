// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Minimal ERC-20 interface to fetch balances
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract GoldenRatioChecker {

    // Define the constant for the Golden Ratio with extended precision
    uint256 private constant PHI_PRECISION = 100000000000;  // Using precision to 10 decimal places
    uint256 private constant PHI_VALUE = 161803398875;  // Represents 1.61803398875 (Golden Ratio to 10 decimal places)

    // Mapping to store scores for each address
    mapping(address => uint256) public scores;

    // Event to log the Golden Ratio check results
    event GoldenRatioChecked(address indexed caller, uint256 deviation, uint256 totalScore);

    // Check the Golden Ratio balance between two given assets for a given address and update the score
    function checkGoldenRatio(address caller, address assetOne, address assetTwo) external {
        // Fetch balances of the two assets for the given address
        uint256 balanceOne = IERC20(assetOne).balanceOf(caller);
        uint256 balanceTwo = IERC20(assetTwo).balanceOf(caller);

        require(balanceTwo != 0, "Asset2 balance should not be zero");  // Prevent division by zero

        // Calculate the ratio with extended precision
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

        // Emit the event with the caller's address, deviation, and total score
        emit GoldenRatioChecked(caller, deviation, scores[caller]);
    }
}
