@isTest
public with sharing class TestManageVotings {
    @testSetup
    static void setup() {
      Voting_Location__c newLocation = new Voting_Location__c(Name='Testowe', Country__c='Poland', City__c='Lublin');
        Database.insert(newLocation);
        
        Voting_Campaign__c newCampaign = 
            new Voting_Campaign__c(Name='TestCampaign',Start_Date__c=System.today(), End_Date__c=System.today()+2, 
                                   Age_Range__c='46-55', Status__c='In progress', VotingLocation__c=newLocation.Id); 

        Database.insert(newCampaign);
        Voting__c newVoting = new Voting__c(Name='TestVoting', Voting_Campaign__c=newCampaign.Id);
        Database.insert(newVoting);
        Voting_Question_Option__c newOption = new Voting_Question_Option__c(Name='VotingOptionTest', Voting__c=newVoting.Id);
        Database.insert(newOption);
    }

    @isTest
    static void testGetVotingsWithoutAnsSuccess(){
        Voting_Campaign__c campaign = [select Id from Voting_Campaign__c where Name = 'TestCampaign' limit 1];
        Voting__c voting = [select Id from Voting__c where Name = 'TestVoting' limit 1];
        User user = [select Id from User where Age_Range__c='46-55' limit 1];
        Voting_Question_Option__c question = [select Id from Voting_Question_Option__c where Name = 'VotingOptionTest' limit 1];
        System.runAs(user) {
            Vote__c newVote = new Vote__c(Voting_Campaign__c=campaign.Id, Voting__c=voting.Id,Voting_Question_Option__c=question.Id);
            List<Voting__c> afterAnswer = ManageVotings.getVotingsWithoutAns(campaign.Id);
            system.assertEquals(0, afterAnswer.size(), 'Incorrectly counted votes');
        }
    }
}
