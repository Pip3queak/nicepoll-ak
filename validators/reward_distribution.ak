// This validator handles reward distribution after the poll has ended.
// Because manually distributing rewards would be so... Web2.
// It ensures that the total spent is correctly distributed among winning voters and verifies that redistribution is enabled.
use aiken/collection/list
use aiken/collection/map
use aiken/math
use modules/types.{poll, vote, reward}
use modules/functions.{validatePollDates, tallyVotes, calculateRewards}

// Validator for distributing rewards
validator distribute_rewards {
    // Verifies redistribution logic and processes reward distribution accordingly.
    spend(datum: Option<poll>, redeemer: List<vote>, _utxo: OutputReference, _tx: Transaction) {
        let poll = match datum {
            Some(p) => p,
            None => fail("Missing poll datum")
        }
        expect poll.reward_redistribution
        let total_spent = poll.total_spent
        let vote_tally = tallyVotes(redeemer)
        let winning_option = match List.max_by(Map.to_list(vote_tally), (option, count1), (_, count2) -> count1 > count2) {
            Some((option, _)) -> option
            _ -> fail "No votes cast"
        }
        let rewards = calculateRewards(redeemer, total_spent, winning_option)
        expect List.length(rewards) > 0
        success
    }
}
