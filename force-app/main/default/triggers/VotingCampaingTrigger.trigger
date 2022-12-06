trigger VotingCampaingTrigger on Voting_Campaign__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
   TriggerDispatcher.run(new VotingCampaignTriggerHandler());

}