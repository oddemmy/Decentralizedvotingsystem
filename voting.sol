// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    // Struct to store candidate details
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    // Struct to store election details
    struct Election {
        string title;
        uint256 deadline;
        bool active;
        mapping(address => bool) hasVoted;
        Candidate[] candidates;
    }

    // State variables
    mapping(uint256 => Election) public elections;
    uint256 public electionCount;

    // Events
    event ElectionCreated(uint256 indexed electionId, string title, uint256 deadline);
    event CandidateAdded(uint256 indexed electionId, string name);
    event VoteCast(uint256 indexed electionId, address voter, uint256 candidateId);
    event ElectionEnded(uint256 indexed electionId);

    // Modifiers
    modifier electionExists(uint256 _electionId) {
        require(_electionId < electionCount, "Election does not exist");
        _;
    }

    modifier electionActive(uint256 _electionId) {
        require(elections[_electionId].active, "Election is not active");
        require(block.timestamp < elections[_electionId].deadline, "Election has ended");
        _;
    }

    constructor() Ownable(msg.sender) {}

    // Create a new election
    function createElection(string memory _title, uint256 _duration) external onlyOwner {
        require(_duration > 0, "Duration must be greater than 0");

        Election storage newElection = elections[electionCount];
        newElection.title = _title;
        newElection.deadline = block.timestamp + _duration;
        newElection.active = true;

        emit ElectionCreated(electionCount, _title, newElection.deadline);
        electionCount++;
    }

    // Add a candidate to an election
    function addCandidate(uint256 _electionId, string memory _name) external onlyOwner electionExists(_electionId) {
        Election storage election = elections[_electionId];
        require(election.active, "Election is not active");

        election.candidates.push(Candidate({
            name: _name,
            voteCount: 0
        }));

        emit CandidateAdded(_electionId, _name);
    }

    // Vote for a candidate
    function vote(uint256 _electionId, uint256 _candidateId) external electionExists(_electionId) electionActive(_electionId) {
        Election storage election = elections[_electionId];
        require(_candidateId < election.candidates.length, "Invalid candidate");
        require(!election.hasVoted[msg.sender], "Already voted");

        election.hasVoted[msg.sender] = true;
        election.candidates[_candidateId].voteCount++;

        emit VoteCast(_electionId, msg.sender, _candidateId);
    }

    // End an election
    function endElection(uint256 _electionId) external onlyOwner electionExists(_electionId) {
        Election storage election = elections[_electionId];
        require(election.active, "Election already ended");
        require(block.timestamp >= election.deadline, "Election not yet ended");

        election.active = false;
        emit ElectionEnded(_electionId);
    }

    // Get election results
    function getElectionResults(uint256 _electionId) external view electionExists(_electionId) returns (
        string memory title,
        Candidate[] memory candidates
    ) {
        Election storage election = elections[_electionId];
        return (election.title, election.candidates);
    }
}
