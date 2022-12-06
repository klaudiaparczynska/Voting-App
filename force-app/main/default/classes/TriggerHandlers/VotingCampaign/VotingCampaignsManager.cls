public with sharing class VotingCampaignsManager {
    
    public static void dateValidation(List<Voting_Campaign__c> newRecords) {
        for(Voting_Campaign__c campaign : newRecords)
        {
            if(campaign.Start_Date__c < System.today() || campaign.End_Date__c < campaign.Start_Date__c)
            {
                campaign.addError('Set correct dates!');
            }
        }  
    }
    
    public static void statusChangeValidation(List<Voting_Campaign__c> newRecords) {
        for(Voting_Campaign__c campaigns : newRecords)
        {
            if(campaigns.Status__c == 'Planned')
            {
                campaigns.addError('Camapign Status cannot be changed to Planned!');
            }
        }  
    }

    public static void nameValidation(List<Voting_Campaign__c> newRecords) {
        List<String> campaignsNames = new List<String>();
        for(Voting_Campaign__c camp : [select Name from Voting_Campaign__c])
        {
            campaignsNames.add(camp.Name);
        }
        for(Voting_Campaign__c newCampaigns : newRecords)
        {
            if(campaignsNames.contains(newCampaigns.Name)) 
            {
                newCampaigns.addError('Campaign Name has to be unique!');
            }
        }
    }

}
