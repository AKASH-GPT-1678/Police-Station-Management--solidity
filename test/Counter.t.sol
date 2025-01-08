//I am commennt
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PoliceStation} from "../src/Station.sol";

contract CounterTest is Test {
    PoliceStation public counter;

    enum CaseCategory {
        Theft,
        Assault,
        Fraud,
        MissingPerson,
        Narcotics
    }

    function setUp() public {
        counter = new PoliceStation();
        console.log("Set up is being completed");
    }

    function testAddOfficer() public {
        address officer = address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        PoliceStation.Post post = PoliceStation.Post.DGP;
        string memory name = "John Doe";
        uint256 salary = 100000;
        uint104 id = 1;
        uint256 age = 30;
        PoliceStation.CaseCategory speciality = PoliceStation.CaseCategory.Fraud;

        counter.addOfficer(
            officer,
            post,
            name,
            salary,
            id,
            age,
            speciality
        );

        (
            address storedOfficer,
            PoliceStation.Post storedPost,
            string memory storedName,
            uint256 storedSalary,
            uint104 storedId,
            uint256 storedAge,
            PoliceStation.CaseCategory storedspeciality
        ) = counter.officers(0);

        // Assertions
        assertEq(storedOfficer, officer);
        assertEq(uint(storedPost), uint(post));
        assertEq(storedName, name);
        assertEq(storedSalary, salary);
        assertEq(storedId, id);
        assertEq(storedAge, age);
        assertEq(uint(storedspeciality), uint(speciality));
    }
}