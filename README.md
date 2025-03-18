# Web3 Car Marketplace

A decentralized marketplace for buying and selling vehicles using blockchain technology and NFTs.

## 📋 Project Overview

This project creates a decentralized car marketplace where:
- Dealers can register and list vehicles for sale
- Each vehicle is represented as a unique NFT (Non-Fungible Token)
- Buyers can purchase vehicles directly through smart contracts
- Vehicle history and ownership is transparently tracked on the blockchain

## 🚗 Key Features

- **NFT-Based Vehicle Representation**: Each car is a unique digital asset with verifiable ownership
- **Dealer Registration System**: Verified sellers with deposit requirements
- **Transparent Vehicle History**: Immutable record of ownership and service history
- **Direct Peer-to-Peer Transactions**: No intermediaries needed for buying/selling
- **On-Chain & Off-Chain Data**: Efficient storage of vehicle information
- **User-Friendly Interface**: Abstract blockchain complexity from end users

## 🔧 Technical Architecture

### Smart Contracts

1. **CarMarketplaceNFT Contract**:
   - Inherits from OpenZeppelin's ERC721 standard
   - Handles minting, ownership, and transfers of vehicle NFTs
   - Manages vehicle metadata and on-chain information

2. **Key Data Structures**:
   ```solidity
   struct CarInfo {
       string make;
       string model;
       uint256 year;
       string vin;
       uint256 price;
       address dealer;
       bool forSale;
   }
   
   struct Dealer {
       string email;
       string name;
       uint256 registrationTimestamp;
       uint256 depositAmount;
       bool isActive;
   }
   ```

### Core Functions

1. **Dealer Registration**:
   ```solidity
   function registerDealer(string memory _email, string memory _name) external payable
   ```

2. **Vehicle Listing (NFT Minting)**:
   ```solidity
   function mintCarNFT(
       string memory _make,
       string memory _model,
       uint256 _year,
       string memory _vin,
       uint256 _price,
       string memory _tokenURI
   ) external onlyRegisteredDealer returns (uint256)
   ```

3. **Purchase System**:
   ```solidity
   function buyCar(uint256 _tokenId) external payable
   ```

4. **Vehicle History Tracking**:
   ```solidity
   function addCarHistory(uint256 _tokenId, string memory _eventType, string memory _description) external
   ```

## 🛠️ Development Setup

### Prerequisites

- Node.js and npm
- Solidity development environment (Truffle, Hardhat, or Remix)
- MetaMask or similar Web3 wallet
- IPFS account for metadata storage (Pinata recommended)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/web3-car-marketplace.git
   cd web3-car-marketplace
   ```

2. Install dependencies:
   ```bash
   npm install
   npm install @openzeppelin/contracts
   ```

3. Configure environment:
   ```bash
   cp .env.example .env
   # Edit .env with your variables
   ```

4. Compile contracts:
   ```bash
   npx hardhat compile
   # or using truffle
   truffle compile
   ```

5. Deploy contracts:
   ```bash
   npx hardhat run scripts/deploy.js --network [network]
   # or using truffle
   truffle migrate --network [network]
   ```

### Using Remix (Alternative)

1. Open [Remix IDE](https://remix.ethereum.org/)
2. Create a new file named `CarMarketplaceNFT.sol`
3. Import OpenZeppelin dependencies (Either by installing via Package Manager or using GitHub URLs):
   ```solidity
   import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
   // For older versions:
   import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/utils/Counters.sol";
   ```
4. Compile and deploy using Remix deployment tab

## 📝 Vehicle Listing Process

1. **Prepare Metadata**:
   - Create JSON file with vehicle details:
     ```json
     {
       "name": "2023 Tesla Model 3",
       "description": "Electric sedan with 82k miles",
       "image": "ipfs://bafybeihvhgwkl54...",
       "attributes": [
         {"trait_type": "Make", "value": "Tesla"},
         {"trait_type": "Model", "value": "Model 3"},
         {"trait_type": "Year", "value": "2023"},
         {"trait_type": "VIN", "value": "5YJ3E1EA5PF..."},
         {"trait_type": "Mileage", "value": "82000"}
       ]
     }
     ```
   - Upload to IPFS to get a CID (Content Identifier)

2. **Register as Dealer**:
   - Pay registration fee
   - Provide required information

3. **Mint Vehicle NFT**:
   - Call `mintCarNFT` function with vehicle details
   - Include IPFS URI as `_tokenURI` parameter

4. **List for Sale**:
   - Set price and availability

## 🔄 Purchase Process

1. **Browse Listings**:
   - View available vehicles
   - Check details and ownership history

2. **Purchase**:
   - Call `buyCar` function with the vehicle's token ID
   - Include required payment amount

3. **Transfer**:
   - NFT transfers to buyer's wallet
   - Payment transfers to seller
   - Ownership record updated on blockchain

## 🔐 Security Considerations

- **Escrow Mechanism**: Consider adding escrow for high-value transactions
- **Validation**: Include additional VIN validation
- **Upgradability**: Plan for contract upgrades as needed
- **Gas Optimization**: Store minimal data on-chain, use IPFS for details
- **Price Oracles**: For supporting multiple payment tokens

## 📈 Future Enhancements

- **Dispute Resolution**: Add mechanism for resolving transaction disputes
- **Fractional Ownership**: Enable multiple people to own shares of vehicles
- **Integration with DeFi**: Add financing options for vehicle purchases
- **IoT Integration**: Connect with vehicle telematics for real-time data
- **Cross-Chain Support**: Enable NFTs to work across multiple blockchains

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request



## 📞 Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter) - email@example.com

