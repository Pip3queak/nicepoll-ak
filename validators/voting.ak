// This validator handles the voting process.
// It ensures people don't vote for imaginary options or vote multiple times—this isn't a reality TV show!
// It ensures that voters can only vote if their choice exists and follows the poll's rules.
use aiken/collection/list
use aiken/collection/map
use modules/types.{poll, vote, reward}

// Validator for casting votes
validator vote_cast {
    // Enforces voting rules such as option existence and multiple voting policies.
    spend(datum: Option<poll>, redeemer: vote, _utxo: OutputReference, tx: Transaction) {
        let poll = match datum {
            Some(p) => p,
            None => fail("Missing poll datum")
        }
        expect redeemer.amount > 0
        expect Map.member(poll.votes, redeemer.option)
        expect poll.multiple_options || !List.member(tx.inputs, redeemer.voter)
        success
    }
}
