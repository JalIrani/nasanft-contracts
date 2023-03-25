// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Uncomment this line to use console.log
import "hardhat/console.sol";

//TODO: if we want all accounts that own a certain
contract NasaFT is ERC1155 {
    address payable public contractOwner;

    constructor() ERC1155("https://game.example/api/item/") {
        contractOwner = payable(msg.sender);
    }

    /**
     * @dev This can be added to the signiture of functions that can only
     * be called by the contract owner.
     */
    modifier mustBeContractOwner() {
        require(
            msg.sender == contractOwner,
            "Only the contract owner can perform this operation. This transaction will be reverted."
        );
        _;
    }

    /**
     * @dev This allows the owner to mint tokens externally
     */
    function mintTokens(uint256 id, uint256 copies) external mustBeContractOwner {
        _mint(contractOwner, id, copies, "");
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
    ) public virtual override mustBeContractOwner {
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
    ) public virtual override mustBeContractOwner {
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev See {ERC1155-safeBatchTransferFrom}.
     * Overridden to make it a contract owner only operation.
     */
    function uri(uint256 id)
        public
        view
        virtual
        override
        mustBeContractOwner
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(super.uri(id), Strings.toString(id), ".json")
            );
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
        mustBeContractOwner
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
        mustBeContractOwner
        returns (uint256[] memory)
    {
        return super.balanceOfBatch(accounts, ids);
    }
}
