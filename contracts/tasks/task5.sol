
// handle access control/permission
contract ProxyStorage {
    address public implementation;
}


contract Proxy is ProxyStorage {

    constructor(address _impl) public {
        // check that its valid before setting the address
        implementation = _impl;
    }

    function setImplementation(address _impl) public {
        implementation = _impl;
    }

    function () public {
        address localImpl = implementation;
         //solium-disable-next-line security/no-inline-assembly
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, localImpl, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

}


contract ScoreStorage {

    uint256 public score;
    // address lastPersonToSetTheScore;

}

contract Score is ProxyStorage, ScoreStorage {

    function setScore(uint256 _score) public {
        score = _score;
    }
}

contract ScoreV2 is ProxyStorage, ScoreStorage {

    function setScore(uint256 _score) public {
        score = _score + 1;
    }
}

/**
    Proper way
 */


// contract ScoreV3 is ProxyStorage, ScoreStorage {

//     function setScore() public {
//         lastPersonToSetTheScore = msg.sender;
//     }
// }


// /**
//     NOT PROPER WAY
//  */
// contract ScoreStorage {

//     address lastPersonToSetTheScore;

// }
// contract ScoreV3 is ProxyStorage, ScoreStorage {

//     function setScore() public {
//         lastPersonToSetTheScore = msg.sender;
//     }
// }