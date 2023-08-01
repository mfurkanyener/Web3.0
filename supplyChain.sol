// SPDX-License-Identifier: MIT
//mfurkanyener

pragma solidity ^0.8.0;

//üretici - fabrika - depo - mağaza

//ürün ekle (barkod mapping)
//aktar (Sıra takibi)
//satıldı (Silme)
//show (ürün nerede?)

contract ProductContract {
    mapping(uint256 => string) public productLocations;

    address public manufacturer;
    address public factory;
    address public warehouse;
    address public store;

    constructor(address _factory, address _warehouse, address _store) {
        manufacturer = msg.sender;
        factory = _factory;
        warehouse = _warehouse;
        store = _store;
    }

    modifier onlyRole(Role _role) {
        if (_role == Role.Manufacturer) {
            require(msg.sender == manufacturer, "Only manufacturer can perform this action");
        } else if (_role == Role.Factory) {
            require(msg.sender == factory, "Only factory can perform this action");
        } else if (_role == Role.Warehouse) {
            require(msg.sender == warehouse, "Only warehouse can perform this action");
        } else if (_role == Role.Store) {
            require(msg.sender == store, "Only store can perform this action");
        } else {
            revert("Invalid role");
        }
        _;
    }

  enum Role { Manufacturer, Factory, Warehouse, Store }

    function addProductLocation(uint256 barcode, string memory location) public onlyRole(Role.Manufacturer) {
        require(barcode > 0, "Invalid barcode");
        require(bytes(location).length > 0, "Invalid location");

        productLocations[barcode] = location;
    }

    function transferToFactory(uint256 barcode, string memory location) public onlyRole(Role.Manufacturer) {
        require(barcode > 0, "Invalid barcode");
        require(bytes(location).length > 0, "Invalid location");

        productLocations[barcode] = location;
    }

    function transferToWarehouse(uint256 barcode, string memory location) public onlyRole(Role.Factory) {
        require(barcode > 0, "Invalid barcode");
        require(bytes(location).length > 0, "Invalid location");

        productLocations[barcode] = location;
    }

    function transferToStore(uint256 barcode, string memory location) public onlyRole(Role.Warehouse) {
        require(barcode > 0, "Invalid barcode");
        require(bytes(location).length > 0, "Invalid location");

        productLocations[barcode] = location;
    }
     function isProductOwnedByRole(uint256 barcode, Role _role) private view returns (bool) {
        if (_role == Role.Factory) {
            return bytes(productLocations[barcode]).length > 0 && bytes(productLocations[barcode])[0] == bytes("Factory")[0];
        } else if (_role == Role.Warehouse) {
            return bytes(productLocations[barcode]).length > 0 && bytes(productLocations[barcode])[0] == bytes("Warehouse")[0];
        } else if (_role == Role.Store) {
            return bytes(productLocations[barcode]).length > 0 && bytes(productLocations[barcode])[0] == bytes("Store")[0];
        }
        return false;
    }
}