public with sharing class ManageVotingCampaigns {
    public ManageVotingCampaigns() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Voting_Campaign__c> getVotingCamp(){
        return [select Id, Name, Start_Date__c, End_Date__c, Status__c, Age_Range__c from Voting_Campaign__c];
    }

    
    @AuraEnabled(cacheable=true)
    public static List<Voting_Campaign__c> getActiveVotingCamp(){
        return [select Id, Name, Start_Date__c, End_Date__c, Status__c from Voting_Campaign__c where Status__c = 'In progress' and Id in (select Voting_Campaign__c from Voting__c)];
    }

    @AuraEnabled(cacheable=true)
    public static List<Voting_Campaign__c> getEndingCampaigns(){
        Date todaysDate = System.today();
        return [select Id, Name, End_Date__c, Status__c from Voting_Campaign__c where (Status__c != 'Stopped' and End_Date__c = :todaysDate)];
    }

}
