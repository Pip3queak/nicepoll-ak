// This module contains utility functions that help with vote tallying, poll validation, and reward calculations.
// These functions will be used by the validators to enforce rules within transactions.
use aiken/collection/list
use aiken/collection/map
use aiken/math

// Ensures that the poll's start date is before the end date.
// No, you cannot create a poll that ends yesterday. Nice try.
pub fn validatePollDates(start_date: Int, end_date: Int) -> Bool {
    start_date < end_date
}

// Tallies votes per option by aggregating the vote amounts.
// Also known as 'Let’s make sure democracy is working as intended' function.
pub fn tallyVotes(votes: List<vote>) -> Map<String, Int> {
    List.fold(votes, Map.new(), acc, vote ->
        Map.insert_with(acc, vote.option, old -> old + vote.amount, vote.amount)
    )
}

// Calculates the proportional rewards for voters who chose the winning option.
// Basically, "Congratulations! You guessed correctly! Here's your reward."
pub fn calculateRewards(votes: List<vote>, total_spent: Int, winning_option: String) -> List<reward> {
    let winners = List.filter(votes, vote -> vote.option == winning_option)
    let total_winner_votes = List.fold(winners, 0, acc, vote -> acc + vote.amount)
    List.map(winners, vote -> {
        recipient: vote.voter,
        amount: Math.div(vote.amount * total_spent, total_winner_votes)
    })
}
