
# Decentralized Voting System
A Solidity smart contract for secure decentralized elections, built to show off intermediate-to-advanced Solidity skills.

# Features
- Admins create elections with titles and durations.
- Add candidates to active elections.
- Users vote once per election, tracked via mappings.
- Elections end after deadlines with viewable results.
- Uses OpenZeppelin’s Ownable for admin control.
- Events log election creation, candidates, votes, and endings.

# How It Works
- Admins create elections with `createElection`.
- Add candidates with `addCandidate`.
- Users vote with `vote`, and admins end elections with `endElection`.
- View results with `getElectionResults`.
- Built in Remix IDE.

# Why It’s Awesome
- Shows structs, nested mappings, and time-based logic.
- Prevents double-voting with `hasVoted` mapping.
- Auditable for vote manipulation and access control risks, great for security training.

# Setup
1. Clone this repo: `git clone https://github.com/oddemmy/Voting-System`
2. Open `Voting.sol` in Remix IDE (remix.ethereum.org).
3. Import OpenZeppelin contracts for Ownable.

# Security Notes
- `onlyOwner` restricts election management to admins.
- Secure state updates prevent vote tampering.
- Ready for auditing access control and state manipulation flaws.

# License
MIT
