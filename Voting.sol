// SPDX-License-Identifier: MIT

pragma solidity >0.6.1 <0.7.0;

import "./DCIP.sol";

contract Ballot {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    using SafeMath for uint256;

    struct Voter {
        uint256 weight; // weight is accumulated by delegation
        uint256 vote; // index of the voted proposal
        mapping(uint256 => Proposal) proposals;
    }

    // This is a type for a single proposal.
    struct Proposal {
        uint256 id;
        address proposer;
        string name; // short name (up to 32 bytes)
        string proposalType; // type of proposal (up to 32 bytes)
        mapping(address => bool) voted;
        mapping(address => Voter) voters;
        uint256 votersCount; // number of accumulated votes
        uint256 yeaVotePercent;
        uint256 nayVotePercent;
        uint256 totalTokenInvested;
    }

    address public chairperson;
    address public myToken;
    uint256 public totalSupplyOfMyToken;

    mapping(address => Voter) public voters;

    uint256 proposalCount;

    mapping(uint256 => Proposal) public proposals;

    uint256 public startedAt;

    modifier onlyEligibleVoter(address _voter) {
        require(IBEP20(myToken).balanceOf(_voter) > 0);
        _;
    }

    modifier onlyChairman {
        require(msg.sender == chairperson);
        _;
    }

    enum VotingState {Diactive, Active, Expired}

    VotingState state;

    event ProposalCreated(
        uint256 id,
        address proposer,
        bytes32 name,
        bytes32 proposalType
    );
    event VoteStarted();
    event VoteEnded();

    /// Create a new ballot to choose one of `proposalNames`.

    // bytes32[] memory proposalNames
    constructor(address _myToken) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        myToken = _myToken;
        totalSupplyOfMyToken = IBEP20(myToken).totalSupply();
        state = VotingState.Diactive;
    }

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    // function giveRightToVote(address voter) public {
    //     // If the first argument of `require` evaluates
    //     // to `false`, execution terminates and all
    //     // changes to the state and to Ether balances
    //     // are reverted.
    //     // This used to consume all gas in old EVM versions, but
    //     // not anymore.
    //     // It is often a good idea to use `require` to check if
    //     // functions are called correctly.
    //     // As a second argument, you can also provide an
    //     // explanation about what went wrong.
    //     require(
    //         msg.sender == chairperson,
    //         "Only chairperson can give right to vote."
    //     );
    //     require(
    //         !voters[voter].voted,
    //         "The voter already voted."
    //     );
    //     require(voters[voter].weight == 0);
    //     voters[voter].weight = 1;
    // }

    function propose(string memory _proposalName, string memory _proposalType)
        public
        onlyChairman
        onlyEligibleVoter(msg.sender)
    {
        proposalCount++;
        Proposal memory newProposal =
            Proposal({
                id: proposalCount,
                proposer: msg.sender,
                name: _proposalName,
                proposalType: _proposalType,
                votersCount: 0,
                yeaVotePercent: 0,
                nayVotePercent: 0,
                totalTokenInvested: 0
            });

        proposals[newProposal.id] = newProposal;
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint256 proposalID, bool isYea)
        public
        onlyEligibleVoter(msg.sender)
    {
        require(state == VotingState.Active, "Voting has not been started.");
        require(
            block.timestamp > startedAt &&
                block.timestamp < startedAt + 12 hours,
            "Voting has been expired."
        );
        Voter storage _sender = voters[msg.sender];
        uint256 _voterTokenCount = IBEP20(myToken).balanceOf(msg.sender);

        _sender.weight = _voterTokenCount.div(totalSupplyOfMyToken);

        Proposal storage _proposal = proposals[proposalID];
        require(
            _proposal.voted[msg.sender] == false,
            "You already have voted to this proposal."
        );

        _proposal.votersCount++;
        _proposal.voters[msg.sender] = _sender;
        _proposal.voted[msg.sender] = true;
        _proposal.totalTokenInvested = _proposal.totalTokenInvested.add(
            _voterTokenCount
        );

        if (isYea) {
            _proposal.yeaVotePercent = _proposal.nayVotePercent.add(
                _voterTokenCount
            );
        } else {
            _proposal.nayVotePercent = _proposal.nayVotePercent.add(
                _voterTokenCount
            );
        }

        _sender.proposals[proposalID] = _proposal;
    }

    function startVoting() public onlyChairman {
        require(
            block.timestamp > startedAt + 12 hours,
            "Previous voting has not been finished"
        );
        startedAt = block.timestamp;
        state = VotingState.Active;
        emit VoteStarted();
    }

    function forceTerminateVoting() public onlyChairman {
        require(state == VotingState.Active, "Voting has not been started.");
        startedAt = 0;
        state = VotingState.Diactive;
    }
}
