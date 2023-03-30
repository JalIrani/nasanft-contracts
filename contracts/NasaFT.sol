// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Uncomment this line to use console.log
import "hardhat/console.sol";

//TODO: if we want all accounts that own a certain
contract NasaFT is ERC1155, Ownable {
    mapping (uint256 => string) private _uris;

    constructor() ERC1155("") {}

    /**
     * @dev This allows the owner to mint tokens externally
     */
    function mintTokens(address to, uint256 id, uint256 copies) external onlyOwner {
        _mint(to, id, copies, "");
    }

    function burnTokens(address from, uint256 id, uint256 copies) external onlyOwner {
        _burn(from, id, copies);
    }

    /**
     * @dev See {ERC1155-safeTransferFrom}.
     * Overridden to make it a contract owner only operation.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override onlyOwner {
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev See {ERC1155-safeBatchTransferFrom}.
     * Overridden to make it a contract owner only operation.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override onlyOwner {
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function setUri(uint256 id, string memory tokenUri) public onlyOwner
    {
        require(bytes(_uris[id]).length == 0, "The uri for this token has already been set");
        _uris[id] = tokenUri;
    }

    /**
     * @dev See {ERC1155-safeBatchTransferFrom}.
     * Overridden to return uri from map
     */
    function uri(uint256 id)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return _uris[id];
    }

    /**
     * @dev See {ERC1155-balanceOf}.
     * Overridden to make it a contract owner only operation.
     */
    function balanceOf(address account, uint256 id)
        public
        view
        virtual
        override
        onlyOwner
        returns (uint256)
    {
        return super.balanceOf(account, id);
    }

    /**
     * @dev See {ERC1155-balanceOfBatch}.
     * Overridden to make it a contract owner only operation.
     */
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public
        view
        virtual
        override
        onlyOwner
        returns (uint256[] memory)
    {
        return super.balanceOfBatch(accounts, ids);
    }
}
