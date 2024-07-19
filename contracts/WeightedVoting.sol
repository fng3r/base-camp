// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * @title WeightedVoting
 */
contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    struct IssueView {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    uint256 public maxSupply = 1_000_000;

    mapping(address => bool) private hasClaimed;

    Issue[] private issues;

    error AllTokensClaimed();
    error TokensClaimed();

    error NoTokensHeld();

    error QuorumTooHigh(uint256 _quorum);

    error AlreadyVoted();

    error VotingClosed();

    constructor() ERC20("WeightedVotingToken", "WVT") {
        Issue storage issue = issues.push();
        issue.issueDesc = "issue to burn";
        issue.closed = true;
    }

    function claim() external {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        if (totalSupply() + 100 > maxSupply) {
            revert AllTokensClaimed();
        }

        hasClaimed[msg.sender] = true;
        _mint(msg.sender, 100);
    }

    function createIssue(string memory _issueDesc, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }

        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }

        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;

        return issues.length - 1;
    }

    function getIssue(uint256 _issueId) external view returns (IssueView memory) {
        Issue storage issue = issues[_issueId];

        return IssueView({
            voters: issue.voters.values(),
            issueDesc: issue.issueDesc,
            quorum: issue.quorum,
            totalVotes: issue.totalVotes,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            passed: issue.passed,
            closed: issue.closed
        });
    }

    function vote(uint256 _issueId, Vote _vote) external  {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }

        Issue storage issue = issues[_issueId];

        if (issue.closed) {
            revert VotingClosed();
        }

        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        issue.voters.add(msg.sender);
        issue.totalVotes += balanceOf(msg.sender);

        if (_vote == Vote.FOR) {
            issue.votesFor += balanceOf(msg.sender);
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += balanceOf(msg.sender);
        } else {
            issue.votesAbstain += balanceOf(msg.sender);
        }

        if (issue.totalVotes >= issue.quorum) {
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }

            issue.closed = true;
        }
    } 
}