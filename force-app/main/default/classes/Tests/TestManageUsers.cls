@isTest
public with sharing class TestManageUsers {
    @testSetup
    static void setup() {
        Voting_Location__c newLocation = new Voting_Location__c(Name='Testowe', Country__c='Poland', City__c='Lublin');
        Database.insert(newLocation);
        Voting_Campaign__c newCampaign = new Voting_Campaign__c(Name='TestManageUsers',Start_Date__c=System.today(), End_Date__c=System.today()+2, Age_Range__c='46-55', VotingLocation__c=newLocation.Id);
        Database.insert(newCampaign);
    }

    @isTest
    static void testGetGroupMembersSuccess() {
        Voting_Campaign__c newCampaign = [select Id from Voting_Campaign__c where Name = 'TestManageUsers' limit 1];
        Profile voter = [SELECT Id FROM Profile WHERE Name='Voter']; 
        List<User> users = [select Username from User where ProfileId = :voter.Id];
        
        List<User> resultVoter = ManageUsers.getGroupMembers(newCampaign.Id, 'Voter');
        System.assertNotEquals(null, resultVoter, 'No voter was found in the allocated group');
        
        List<User> resultMod = ManageUsers.getGroupMembers(newCampaign.Id, 'Moderator');
        System.assertNotEquals(null, resultMod, 'No moderator was found in the allocated group');

        List<User> resultAna = ManageUsers.getGroupMembers(newCampaign.Id, 'Analyst');
        System.assertNotEquals(null, resultAna, 'No moderator was found in the allocated group');

    }
    @isTest
    static void testGetGroupMembersFailure() {
        Voting_Campaign__c newCampaign = [select Id from Voting_Campaign__c where Name = 'TestManageUsers' limit 1];
        List<User> result = ManageUsers.getGroupMembers(newCampaign.Id, 'Standard User');
        System.assertEquals(null, result, 'No voter was found in the allocated group');
        
    }

}
