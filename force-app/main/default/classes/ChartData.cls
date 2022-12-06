public with sharing class ChartData {
    public ChartData() {

    }
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getVotes(String votingId){
        Id ids = Id.valueOf(votingId);
        return [select count(Id), Voting_Question_Option__r.Name from Vote__c 
                              where Voting__c = :ids group by Voting_Question_Option__r.Name];
    }
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getVotesperVoting(String campaignId){
        Id ids = Id.valueOf(campaignId);
        return [select count(Id), Voting__r.Name from Vote__c where Voting_Campaign__c = :ids group by Voting__r.Name];
    }

    //chart of locations
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> locationsPerVotingCampaigns(){
        return [select count(Id), VotingLocation__r.Name from Voting_Campaign__c group by VotingLocation__r.Name];
    }


}

