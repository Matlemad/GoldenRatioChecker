Just in case someone out there is interested in experimenting with esoteric DeFi.
I'm open to usecase suggestions and improvements.

# GoldenRatioChecker.sol
Checks a wallet's ratio between two given assets and gives back a score

the contract checks the ratio between two given assets held by an address and this ratio's deviation from the Golden Ratio, 
then returns a score. 

the closer the ratio to the Golden Ratio, the closer the score to 0, and viceversa.

The score is then added to the address' score.

Addresses that performs better will see their score's increase slowing down.

# GoldenRatioCheckerPRICE.sol
Same logic but instead of calling the balance, each assett's price is fetched via Chainlink pricefeeds contract.

