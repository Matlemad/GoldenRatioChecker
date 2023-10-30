// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Chainlink Aggregator interface to fetch prices
interface IAggregator {
    function latestAnswer() external view returns (int256);
}

contract GoldenRatioChecker {

    // Define the constant for the Golden Ratio with extended precision
    uint256 private constant PHI_PRECISION = 100000000000;  // Using precision to 10 decimal places
    uint256 private constant PHI_VALUE = 161803398875;  // Represents 1.61803398875 (Golden Ratio to 10 decimal places)

    // Mapping to store scores for each address
    mapping(address => uint256) public scores;

    // Event to log the Golden Ratio check results
    event GoldenRatioChecked(address indexed caller, uint256 deviation, uint256 totalScore);

    // Check the Golden Ratio between the prices of two given assets and update the score
    function checkGoldenRatio(address caller, address assetOneOracle, address assetTwoOracle) external {
        // Fetch prices of the two assets using Chainlink price feeds (oracles)
        int256 assetOnePrice = IAggregator(assetOneOracle).latestAnswer();
        int256 assetTwoPrice = IAggregator(assetTwoOracle).latestAnswer();

        require(assetOnePrice > 0 && assetTwoPrice > 0, "Prices should be positive");
        require(assetTwoPrice != 0, "Asset2 price should not be zero");  // Prevent division by zero

        // Calculate the ratio with extended precision
        uint256 currentRatio = (uint256(assetOnePrice) * PHI_PRECISION) / uint256(assetTwoPrice);

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
