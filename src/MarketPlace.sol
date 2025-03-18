// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./lib/Events.sol";

contract MarketPlace is ERC721URIStorage {
    address public owner;
    uint256 private _nextTokenId;

    constructor() ERC721("CarMarketplace", "CARS") {
        owner = msg.sender;
    }

    //   events

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
        bool isActive;
    }

    uint256 public dealerCount = 0;
    uint256 public carCount = 0;
    uint256 public dealerRegistrationFee = 0.01 ether;

    mapping(address => uint[]) public carsByDealer;
    mapping(address => CarInfo[]) public carBought;
    mapping(uint256 => CarInfo) public carById;
    mapping(address => Dealer) public dealers;
    mapping(address => bool) public isRegistered;

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier onlyRegisteredDealer() {
        require(
            isRegistered[msg.sender],
            "Only registered dealers can perform this action"
        );
        _;
    }

    // register as a dealer/seller
    function registerDealer(
        string memory _email,
        string memory _name
    ) external payable {
        require(msg.sender != address(0), "Invaid Car dealer");
        require(msg.value >= dealerRegistrationFee, "Insufficient funds");
        require(!isRegistered[msg.sender], "Address already registered");

        dealers[msg.sender] = Dealer(_email, _name, block.timestamp, true);
        isRegistered[msg.sender] = true;

        emit Events.DealerRegistered(msg.sender, _name, block.timestamp);
    }

    //  mint Nft for the car first

    function mintNft(
        string memory _make,
        string memory _model,
        uint256 _year,
        string memory _vin,
        uint256 _price,
        string memory _tokenURI
    ) external onlyRegisteredDealer returns (uint256) {
        uint256 newCarId = _nextTokenId++;
        _mint(msg.sender, newCarId);
        _setTokenURI(newCarId, _tokenURI);

        carById[newCarId] = CarInfo(
            _make,
            _model,
            _year,
            _vin,
            _price,
            msg.sender,
            false
        );

        carsByDealer[msg.sender].push(newCarId);

        emit Events.CarMinted(msg.sender, _model, _make, _price);
        return newCarId;
    }

    // list car After minting as nft

    function listCar(uint _carId, uint _price) external {
        require(ownerOf(_carId) == msg.sender, "Not the car owner");
        carById[_carId].price = _price;
        carById[_carId].forSale = true;
    }

    // purchase a car

    function buyCar(uint _carId) external payable {
        CarInfo storage car = carById[_carId];
        require(car.forSale, "Car not Listed");
        require(msg.value >= car.price, "Insufficient Funds");

        address seller = ownerOf(_carId);

        _transfer(seller, msg.sender, _carId);
        car.forSale = false;
        car.dealer = msg.sender;

        payable(seller).transfer(msg.value);
        carBought[msg.sender].push(car);
        emit Events.CarSold(_carId, seller, msg.sender, car.price);
    }

    function getDealerCars(
        address _dealer
    ) external view returns (uint256[] memory) {
        return carsByDealer[_dealer];
    }

    function updateCarPrice(uint256 _tokenId, uint256 _newPrice) external {
        require(ownerOf(_tokenId) == msg.sender, "Not the car owner");
        carById[_tokenId].price = _newPrice;
    }

    function getAllCarsBought(
        address _user
    ) public view returns (CarInfo[] memory) {
        return carBought[_user];
    }
}
