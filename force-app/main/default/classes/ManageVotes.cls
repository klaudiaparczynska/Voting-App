public with sharing class ManageVotes {
    public ManageVotes() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Voting_Question_Option__c> getVotingOptions(String votingId){
        Id ids = Id.valueOf(votingId);
        return [select Name from Voting_Question_Option__c where Voting__c = :ids];
    }

    @AuraEnabled(cacheable=true)
    public static List<Vote__c> getVotesFromCampaign(String campaignId){
        Id ids = Id.valueOf(campaignId);
        Id userId = userInfo.getUserId();
        return [select Voting__r.Name, Voting_Campaign__r.Name, Voting_Question_Option__r.Name from Vote__c where Voting_Campaign__c = :ids and OwnerId = :userId];
    }
}
