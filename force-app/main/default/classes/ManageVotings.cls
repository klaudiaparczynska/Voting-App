public with sharing class ManageVotings {
    public ManageVotings() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Voting__c> getList(String recordId) {
        Id ids = Id.valueOf(recordId);
        return [select Id, Name, Voting_Type__c from Voting__c where Voting_Campaign__r.Id = :ids];
    }

    
    @AuraEnabled(cacheable=true)
    public static List<Voting__c> getVotingsWithoutAns(String recordId) {
        Id ids = Id.valueOf(recordId);
        return [select Id, Name from Voting__c where Id not in (select Voting__c from Vote__c) and Voting_Campaign__r.Id = :ids];
    }
}
