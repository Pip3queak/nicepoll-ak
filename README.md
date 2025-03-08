This is my heroic yet slightly misguided attempt at creating a fun dApp on the Cardano blockchain using Aiken.

Due to time and personal life constraints, I couldn’t fully complete the project for the submission date. However, to demonstrate my understanding, I’m sharing the handlers, possible functions, and types.

I acknowledge that the code doesn’t compile—yes, I know, and no, I’m not a wizard... yet! But progress is progress.

My goal wasn’t to become a full-blown smart contract developer, but rather to deepen my understanding of smart contracts and my love for eUTXO, and I’ve achieved that. One key takeaway is that on-chain code has its limits—some tasks, like reward redistribution, require an off-chain bot to trigger fund releases.

This isn’t the end of my smart contract journey. I plan to clean up and compile the Aiken code, then move on to front-end development with Next.js or Svelte, whichever feels right. It’s going to be a slow and painful process, but I’ll get there... eventually.

![BPMN diagram of nicepoll app]([https://github.com/Pip3queak/nicepoll-ak/blob/main/nicepoll.png "BPMN of Nicepoll")


# **NicePoll: Software Requirement Specification (SRS)**

AIKEN\_Emurgo-Batch-EWPGBL00114

## **1\. Introduction**

**NicePoll** is a decentralized application (dApp) built on the Cardano blockchain that allows users to participate in polls by spending ADA or a native token, **NicePoll Token**. Users cast their votes by spending ADA or NicePoll Tokens, and the tokens from losing votes are automatically redistributed to participants who voted for the winning options. Poll creators have the option to turn off reward redistribution, allowing for more flexible use cases like opinion polls or charity-driven voting. NicePoll uses smart contracts to ensure secure, transparent, and decentralized polling and reward distribution, leveraging Cardano’s multi-address transactions for direct reward distribution.

### **1.1 Problem Statement**

Traditional polling systems lack engagement and incentives for participation. NicePoll addresses this by allowing users to vote with real value, creating a more engaging and rewarding polling experience. Additionally, polls can be created with or without reward redistribution, giving creators more control over the nature of the poll. All rewards are automatically distributed using multi-address transactions, eliminating the need for users to manually claim them.

### **1.2 Project Goals**

* Allow users to create polls with multiple options.
* Enable users to cast votes by spending ADA or the native NicePoll Token.
* Provide poll creators with the option to turn off reward redistribution.
* Redistribute tokens from losing votes to winning voters (if enabled) automatically.
* Ensure the polling process is transparent, fair, and decentralized through smart contracts.

## **2\. Architecture**

### **2.1 Contract Structure**

NicePoll consists of smart contracts that manage poll creation, voting, and automatic reward distribution. The core components include:

* **Poll Creation Contract**: Allows users to create a poll by specifying a question, voting options, and various parameters for the poll.
* **Voting Contract**: Manages the vote casting by spending ADA or NicePoll Tokens and updates the poll results accordingly.
* **Reward Distribution Contract**: Redistributes the tokens spent by losing voters to those who voted for winning options proportionally (if enabled) using multi-address transactions.

### **2.2 Key Components**

#### **2.2.1 Poll Struct**

The Poll struct stores the following information:

* `creator`: Address of the poll creator.
* `question`: The poll's question.
* `options`: List of vote options.
* `votes`: Mapping of options to the number of votes.
* `total_spent`: Total ADA or NicePoll Tokens spent.
* `start_date`: The date the poll begins.
* `end_date`: The date the poll ends.
* `fixed_amount`: Optional parameter for whether the amount of ADA or NicePoll Tokens spent per vote is fixed or variable.
* `max_votes`: Optional parameter for setting the number of times a voter can spend to vote.
* `multiple_options`: Boolean indicating whether voters can cast votes for more than one option.
* `reward_redistribution`: Boolean that indicates whether reward redistribution is enabled.

#### **2.2.2 Voting Mechanism**

* Users cast their votes by selecting an option and **spending** ADA or NicePoll Tokens.
* Each vote represents a transaction where ADA or tokens are irreversibly spent.
* The Voting Contract updates the vote count and tracks the total spent for each option.
* The poll creator may allow voters to vote multiple times or on more than one option.
* If reward redistribution is enabled, the Voting Contract will store the tokens for redistribution at the end of the poll. If not, no rewards will be redistributed.

#### **2.2.3 Reward Redistribution**

* If reward redistribution is enabled, after the poll ends, the total amount spent on losing options is calculated.
* Winning voters receive a proportionate share of the total amount spent based on the number of votes they cast for the winning option.
* All rewards are automatically distributed using Cardano's **multi-address transactions**.
* If reward redistribution is turned off, the poll ends without any redistribution of tokens.
* A small transaction fee is deducted to cover the cost of smart contract execution (if reward redistribution is enabled).

## **3\. Requirements**

### **3.1 Functional Requirements**

1. **Poll Creation**:
   * Users must be able to create a poll by submitting a question and at least two options.
   * The poll creator must specify a start date and an end date for the poll.
   * The poll creator can optionally:
     * Set a fixed amount of ADA or NicePoll Tokens that each vote costs.
     * Allow voters to spend multiple times on the same poll or limit it to a single vote.
     * Specify whether voters can cast votes for more than one option in the poll.
     * **Enable or disable reward redistribution**: Poll creators can choose whether the tokens from losing votes are redistributed to winning voters or not.
2. **Voting**:
   * Users cast their vote by **spending** ADA or NicePoll Tokens.
   * Each vote transaction is irreversible; tokens are transferred upon casting a vote.
   * Depending on poll settings, users may be allowed to vote multiple times or cast votes for more than one option.
   * Users can vote only once per poll unless the poll creator allows multiple votes.
3. **Reward Distribution**:
   * If reward redistribution is enabled, tokens spent on losing votes are redistributed to the voters who supported the winning options.
   * The redistribution is proportional to the amount spent by each winning voter.
   * If reward redistribution is turned off, the poll ends without redistribution, and users receive no rewards.
   * **Rewards are automatically distributed** to winning voters using **Cardano’s multi-address transactions**, ensuring that users do not need to claim rewards manually.
   * A small fee is deducted from the pool before redistribution (if enabled).
4. **Result Calculation**:
   * The option with the most votes (ADA or NicePoll Tokens spent) is considered the winner.
   * If there is a tie, rewards (if enabled) are evenly distributed among the tied options.
5. **Poll Termination**:
   * After the end date, the poll is locked, and no further votes can be cast.
   * If enabled, rewards are automatically distributed to the winning voters via smart contracts.
6. **Token Integration**:
   * The platform supports only **ADA and NicePoll Tokens** for spending in the polls.

### **3.2 Non-Functional Requirements**

1. **Security**:
   * All smart contracts must undergo thorough auditing to prevent vulnerabilities.
   * Users' vote transactions should be irreversible, ensuring immutability and fairness.
2. **Transparency**:
   * All poll data and transactions must be fully visible on the Cardano blockchain, enabling users to verify results.
3. **Scalability**:
   * The system must handle multiple concurrent polls with a high volume of transactions without performance degradation.
4. **User Experience**:
   * The UI should be intuitive, offering clear information on how much ADA or NicePoll Tokens users are spending, the potential rewards (if enabled), and the poll’s status.

### **3.3 Constraints**

* The NicePoll dApp must comply with Cardano's transaction and fee structures.
* Poll results and reward distribution must be handled in a decentralized manner to prevent manipulation.

## **4\. Workflow**

### **4.1 Poll Creation Flow**

1. A user connects to the NicePoll dApp using a Cardano wallet.
2. The user creates a poll by specifying a question, options, start date, end date, and any optional parameters (fixed amount, max votes, multiple options, reward redistribution).
3. The Poll Creation Contract records the poll on-chain and begins tracking votes.

### **4.2 Voting Flow**

1. A user selects a poll and an option to vote for.
2. The user **spends** ADA or NicePoll Tokens to cast their vote, initiating a blockchain transaction.
3. Depending on poll settings, the user may vote multiple times or for more than one option.
4. The Voting Contract records the transaction, updates the total votes for the chosen option(s), and locks the spent tokens.

### **4.3 Reward Distribution Flow**

1. Once the poll ends, the Voting Contract tallies the votes and identifies the winning option(s).
2. If reward redistribution is enabled, the total ADA or NicePoll Tokens spent on losing options are transferred to the Reward Distribution Contract.
3. **Rewards are automatically distributed** to the winning voters via **multi-address transactions** without the need for manual claiming.

## **5\. Risk and Mitigation**

### **5.1 Regulatory Compliance**

* **Risk**: Spending ADA or tokens for voting may be classified as gambling or financial speculation in some jurisdictions.
* **Mitigation**: Ensure compliance with local regulations by providing legal disclaimers and restricting access where necessary.

### **5.2 Smart Contract Bugs**

* **Risk**: Bugs in the smart contract could result in incorrect token redistribution or loss of funds.
* **Mitigation**: Implement extensive testing and audits of the contracts before deployment.

### **5.3 Network Congestion**

* **Risk**: High transaction volume during polling periods could lead to delays in vote processing or reward distribution.
* **Mitigation**: Consider using Layer 2 solutions or batching transactions to improve scalability.

## **6\. Conclusion**

NicePoll offers a novel approach to polling by integrating financial stakes into the voting process. By spending ADA or NicePoll Tokens to vote, users increase engagement and stand a chance to win redistributed rewards. Poll creators also have the flexibility to turn off reward redistribution, making the platform suitable for a wide range of polling use cases. With rewards automatically distributed via smart contracts, the system is fully decentralized and eliminates the need for manual claiming, ensuring a seamless and transparent experience for all participants.
