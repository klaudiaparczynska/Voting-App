trigger VotingLocationTrigger on Voting_Location__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    TriggerDispatcher.run(new VotingLocationTriggerHandler());

}