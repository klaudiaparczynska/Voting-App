@isTest
private with sharing class TestVotingLocation {
    @testSetup
  static void setup() {
    Voting_Location__c newLocation = new Voting_Location__c(
      Name = 'Testowe',
      Country__c = 'Poland',
      City__c = 'Lublin'
    );
    Database.insert(newLocation);
    
  }
    @isTest 
    static void testalidateUniquenessSuccess() {
        Voting_Location__c repeatedLocation = new Voting_Location__c(Name='Testowe2', Country__c='Poland', City__c='Lublin');
        Test.startTest();
        Database.SaveResult result = Database.insert(repeatedLocation);
        Test.stopTest();
        system.assert(result.isSuccess(), 'Location Names have to be unique');
    }
    @isTest 
    static void testalidateUniquenessFailure() {
        Voting_Location__c repeatedLocation = new Voting_Location__c(Name='Testowe', Country__c='Poland', City__c='Lublin');
        Test.startTest();
        Database.SaveResult result = Database.insert(repeatedLocation);
        Test.stopTest();
        system.assert(!result.isSuccess(), 'Location Names have to be unique');
    }
    @isTest 
    static void testalidateUniquenessSuccessBulk() {
        Voting_Location__c repeatedLocation = new Voting_Location__c(Name='Testowe2', Country__c='Poland', City__c='Lublin');
        Voting_Location__c repeatedLocation2 = new Voting_Location__c(Name='Testowe3', Country__c='Poland', City__c='Lublin');
        List<Voting_Location__c> locationsToInsert = new List<Voting_Location__c> {repeatedLocation, repeatedLocation2};
        Test.startTest();
        List<Database.SaveResult> result = Database.insert(locationsToInsert);
        Test.stopTest();
        for(Database.SaveResult res : result)
        {
            system.assert(res.isSuccess(), 'Location Names have to be unique');
        }
    }

    @isTest 
    static void testalidateUniquenessFailureBulk() {
        Voting_Location__c repeatedLocation = new Voting_Location__c(Name='Testowe2', Country__c='Poland', City__c='Lublin');
        Voting_Location__c repeatedLocation2 = new Voting_Location__c(Name='Testowe2', Country__c='Poland', City__c='Lublin');
        List<Voting_Location__c> locationsToInsert = new List<Voting_Location__c> {repeatedLocation, repeatedLocation2};
        Test.startTest();
        List<Database.SaveResult> result = Database.insert(locationsToInsert);
        Test.stopTest();
        for(Database.SaveResult res : result)
        {
            system.assert(!res.isSuccess(), 'Location Names have to be unique');
        }
    }
}
