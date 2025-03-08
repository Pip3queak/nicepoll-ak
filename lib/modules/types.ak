// This file defines the core data structures used in the NicePoll smart contract.
// The types here represent the Poll, Vote, and Reward models.
// A poll consists of multiple options and tracks votes along with the amount spent.
pub type poll {
    creator: Address,
    question: String,
    options: List<String>,
    votes: Map<String, Int>,
    total_spent: Int,
    start_date: Int,
    end_date: Int,
    fixed_amount: Bool,
    max_votes: Option<Int>,
    multiple_options: Bool,
    reward_redistribution: Bool
}

// Each vote is linked to a voter and an option.
pub type vote {
    voter: Address,
    option: String,
    amount: Int
}

// Rewards structure for distributing funds to winners.
pub type reward {
    recipient: Address,
    amount: Int
}
