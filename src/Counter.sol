// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract PoliceStation {
    uint256 public number;

    event Afsar(string message);

    // Enums
    enum Post {
        DGP,
        SP,
        Inspector,
        SubInspector,
        Constable
    }

    enum CaseCategory {
        Theft,
        Assault,
        Fraud,
        MissingPerson,
        Narcotics
    }
    enum Profile {
        High,
        Average,
        Low
    }

    // Structs
    struct Officer {
        address officer;
        Post post;
        string name;
        uint256 salary;
        uint104 id;
        uint256 age;
        CaseCategory speciality;
    }

    struct Case {
        string victim;
        uint firid;
        string[] evidence;
        uint104 date;
        string officer;
        uint104 officerid;
        bytes32 probsummary;
        CaseCategory category;
        Profile profile;
    }

    struct finances {
        string name;
        uint256 expenses;
        uint[] incomes;
        string recipt;
        string paymenton;
    }

    // Mappings
    mapping(address => Officer) public officerbyaddress;
    mapping(uint104 => Officer) public mapbyid;

    // Arrays
    Officer[] public officers;
    uint[] public incomes;
    uint[] public expenses;
    uint[] public balance;
    finances[] public finance;
    Case[] public cases;

    // Functions

    function addOfficer(
        address _address,
        Post _post,
        string memory _name,
        uint256 _salary,
        uint104 _id,
        uint256 _age,
        CaseCategory _speciality
    ) external {
        Officer memory newOfficer = Officer({
            officer: _address,
            post: _post,
            name: _name,
            salary: _salary,
            id: _id,
            age: _age,
            speciality: _speciality
        });

        officers.push(newOfficer);
        officerbyaddress[_address] = newOfficer;
        mapbyid[_id] = newOfficer;
        emit Afsar(string(abi.encodePacked("Here is the new guy: ", _name)));
    }

    function UpdateOfficer(
        address _address,
        Post _post,
        string memory _name,
        uint256 _salary,
        uint104 _id,
        uint256 _age,
        CaseCategory _speciality
    ) external {
        require(mapbyid[_id].officer != address(0), "Officer not found");

        Officer memory updateOfficer = Officer({
            officer: _address,
            post: _post,
            name: _name,
            salary: _salary,
            id: _id,
            age: _age,
            speciality: _speciality
        });

        mapbyid[_id] = updateOfficer;

        officerbyaddress[_address] = updateOfficer;

        for (uint i = 0; i < officers.length; i++) {
            if (officers[i].id == _id) {
                officers[i] = updateOfficer;
                break;
            }
        }
        emit Afsar(string(abi.encodePacked("Here is the new guy: ", _name)));
    }

    function addincident() external {}

    function Budgetmanement(uint256 _income, uint256 _expenses) external {
        incomes.push(_income);
        expenses.push(_expenses);
        if (_income > 0 && _expenses > 0) {
            uint val = _income - _expenses;
            balance.push(val);
        }
    }

    function getTotal() external view returns (uint256, uint256) {
        uint256 income = 0;
        uint256 expense = 0;

        for (uint i = 0; i < incomes.length; i++) {
            income += incomes[i];
        }

        for (uint i = 0; i < expenses.length; i++) {
            expense += expenses[i];
        }

        return (income, expense);
    }




    function allotCase(
        // string memory _probsummary,
        CaseCategory _case,
        Profile _profile
    ) public view {
        uint count = 0;

        // First pass: Count the matches
        for (uint i = 0; i < officers.length; i++) {
            if (officers[i].speciality == _case) {
                count++;
            }
        }

        // Create a memory array of the exact size
        Officer[] memory selectedOnes = new Officer[](count);

        uint index = 0;

        // Second pass: Populate the array
        for (uint i = 0; i < officers.length; i++) {
            if (officers[i].speciality == _case) {
                selectedOnes[index] = officers[i];
                index++;
            }
        }



        // Create fixed size array for allotted officers
Officer[] memory allottedOfficers = new Officer[](1);

// Loop through selected officers
for(uint i = 0; i < selectedOnes.length; i++) {
    if((selectedOnes[i].post == Post.Constable || 
        selectedOnes[i].post == Post.Inspector) && 
        _profile == Profile.Low) {
        
        // Assign the selected officer to allotted array
        allottedOfficers[0] = selectedOnes[i];
        break; // Stop after first match
    }
}

// Return allotted officer or revert if none found
require(allottedOfficers[0].officer != address(0), "No matching officer found");
    }
}


