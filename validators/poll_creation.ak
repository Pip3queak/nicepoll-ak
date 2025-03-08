// This validator ensures that a poll is valid when it is created.
// In other words, it prevents users from making polls that end before they start—because time travel is not a feature (yet).
// It checks that the poll has valid dates, at least two options, and a non-negative total_spent value.
use aiken/collection/list
use modules/types.{poll, vote, reward}
use modules/functions.{validatePollDates, tallyVotes, calculateRewards}

// Validator for poll creation
validator poll_creation {
    // Ensures poll parameters are valid before allowing creation.
    spend(datum: Option<poll>, _redeemer: Data, _utxo: OutputReference, _tx: Transaction) {
        let poll = match datum {
            Some(p) => p,
            None => fail("Missing poll datum")
        }
        expect validatePollDates(poll.start_date, poll.end_date)
        expect List.length(poll.options) >= 2
        expect poll.total_spent >= 0
        success
    }
}
