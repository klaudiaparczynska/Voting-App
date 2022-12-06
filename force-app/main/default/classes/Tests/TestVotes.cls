@isTest
public with sharing class TestVotes {
    @testSetup
    static void setup() {
        Voting_Location__c newLocation = new Voting_Location__c(Name='Testowe', Country__c='Poland', City__c='Lublin');
        Database.insert(newLocation);
        
        Voting_Campaign__c newCampaign = 
            new Voting_Campaign__c(Name='TestCampaign',Start_Date__c=System.today(), End_Date__c=System.today()+2, 
                                   Age_Range__c='46-55', Status__c='In progress', VotingLocation__c=newLocation.Id); 

        Database.insert(newCampaign);
        Voting__c newVoting = new Voting__c(Name='TestVoting', Voting_Campaign__c=newCampaign.Id);
        Voting__c newVoting2 = new Voting__c(Name='TestVoting2', Voting_Campaign__c=newCampaign.Id);
        List<Voting__c> votingsToAdd = new List<Voting__c> {newVoting, newVoting2};
        Database.insert(votingsToAdd);
        Voting_Question_Option__c newOption = new Voting_Question_Option__c(Name='VotingOptionTest', Voting__c=newVoting.Id);
        Voting_Question_Option__c newOption2 = new Voting_Question_Option__c(Name='VotingOptionTest2', Voting__c=newVoting2.Id);
        List<Voting_Question_Option__c> votingsOptionsToAdd = new List<Voting_Question_Option__c> {newOption, newOption2};
        Database.insert(votingsOptionsToAdd);
    }
    @isTest
    static void testMultipleVoteValidationSuccess() {
        Voting_Campaign__c campaign = [select Id from Voting_Campaign__c where Name = 'TestCampaign' limit 1];
        Voting__c voting = [select Id from Voting__c where Name = 'TestVoting' limit 1];
        Voting_Question_Option__c question = [select Id from Voting_Question_Option__c where Name = 'VotingOptionTest' limit 1];
        
        Vote__c secondVote = new Vote__c(Voting_Campaign__c=campaign.Id, Voting__c=voting.Id,Voting_Question_Option__c=question.Id);
        test.startTest();
        Database.SaveResult result = Database.insert(secondVote);
        test.stopTest();

        system.assert(result.isSuccess(), 'Cannot add two votes from one user!');
    }

    @isTest
    static void testMultipleVoteValidationFailure() {
        Voting_Campaign__c campaign = [select Id from Voting_Campaign__c where Name = 'TestCampaign' limit 1];
        Voting__c voting = [select Id from Voting__c where Name = 'TestVoting' limit 1];
        Voting_Question_Option__c question = [select Id from Voting_Question_Option__c where Name = 'VotingOptionTest' limit 1];
        Vote__c firstVote = new Vote__c(Voting_Campaign__c=campaign.Id, Voting__c=voting.Id,Voting_Question_Option__c=question.Id);
        Vote__c secondVote = new Vote__c(Voting_Campaign__c=campaign.Id, Voting__c=voting.Id,Voting_Question_Option__c=question.Id);

        test.startTest();
        Database.insert(firstVote);
        Database.SaveResult result = Database.insert(secondVote);
        test.stopTest();

        system.assert(!result.isSuccess(), 'Cannot add two votes from one user!');
    }

    @isTest
    static void testMultipleVoteValidationSuccessBulk() {
        Voting_Campaign__c campaign = [select Id from Voting_Campaign__c where Name = 'TestCampaign' limit 1];
        Voting__c voting = [select Id from Voting__c where Name = 'TestVoting' limit 1];
        Voting_Question_Option__c question = [select Id from Voting_Question_Option__c where Name = 'VotingOptionTest' limit 1];
        Voting__c voting2 = [select Id from Voting__c where Name = 'TestVoting2' limit 1];
        Voting_Question_Option__c question2 = [select Id from Voting_Question_Option__c where Name = 'VotingOptionTest2' limit 1];

        Vote__c firstVote = new Vote__c(Voting_Campaign__c=campaign.Id, Voting__c=voting.Id,Voting_Question_Option__c=question.Id);
        Vote__c secondVote = new Vote__c(Voting_Campaign__c=campaign.Id, Voting__c=voting2.Id,Voting_Question_Option__c=question2.Id);
        List<Vote__c> votesToAdd = new List<Vote__c> {firstVote, secondVote};
        test.startTest();
        List<Database.SaveResult> result = Database.insert(votesToAdd);
        test.stopTest();

        for(Database.SaveResult res : result) {
            system.assert(res.isSuccess(), 'Cannot add two votes from one user!');
        }
    }

    @isTest
    static void testMultipleVoteValidationFailureBulk() {
        Voting_Campaign__c campaign = [select Id from Voting_Campaign__c where Name = 'TestCampaign' limit 1];
        Voting__c voting = [select Id from Voting__c where Name = 'TestVoting' limit 1];
        Voting_Question_Option__c question = [select Id from Voting_Question_Option__c where Name = 'VotingOptionTest' limit 1];
        Vote__c firstVote = new Vote__c(Voting_Campaign__c=campaign.Id, Voting__c=voting.Id,Voting_Question_Option__c=question.Id);
        Vote__c secondVote = new Vote__c(Voting_Campaign__c=campaign.Id, Voting__c=voting.Id,Voting_Question_Option__c=question.Id);
        List<Vote__c> votesToAdd = new List<Vote__c> {firstVote, secondVote};
        test.startTest();
        Database.insert(firstVote);
        List<Database.SaveResult> result = Database.insert(votesToAdd);
        test.stopTest();

        for(Database.SaveResult res : result) {
            system.assert(!res.isSuccess(), 'Cannot add two votes from one user!');
        }
    }


    
}
