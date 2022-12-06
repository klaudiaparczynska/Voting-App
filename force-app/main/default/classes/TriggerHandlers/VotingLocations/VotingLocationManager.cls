public with sharing class VotingLocationManager {
    
    public static void validateUniqueness(List<Voting_Location__c> newRecords) {
        List<String> allLocationsNames = new List<String>();
        for(Voting_Location__c location : [select Name, Country__c, City__c, Street__c from Voting_Location__c])
        {
            allLocationsNames.add(location.Name);
        }
        for(Voting_Location__c location : newRecords)
        {
            if(allLocationsNames.contains(location.Name))
            {
                location.addError('Location Names have to be unique!');
            }
        }
    }
}
