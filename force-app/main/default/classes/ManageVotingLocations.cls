public with sharing class ManageVotingLocations {
    public ManageVotingLocations() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Voting_Location__c> getLocations(){
        return [select Name,Country__c, City__c, Street__c, Postal_Code__c from Voting_Location__c];
    }
    @AuraEnabled(Cacheable=true)
    public static List<Voting_Location__c> getLocationFromLocationId(String locationId){
        Id ids = Id.valueOf(locationId);
        return [select Name, Country__c, City__c, Street__c, Postal_Code__c from Voting_Location__c where Id = :ids];
        
    }
}
