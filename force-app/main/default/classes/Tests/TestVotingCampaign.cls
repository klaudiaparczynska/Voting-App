@isTest
private with sharing class TestVotingCampaign {
  @testSetup
  static void setup() {
    Voting_Location__c newLocation = new Voting_Location__c(
      Name = 'Testowe',
      Country__c = 'Poland',
      City__c = 'Lublin'
    );
    Database.insert(newLocation);
    Voting_Campaign__c newCampaign = 
            new Voting_Campaign__c(Name='TestCampaign',Start_Date__c=System.today()+2, End_Date__c=System.today()+3, 
                                   Age_Range__c='46-55', Status__c='In progress', VotingLocation__c=newLocation.Id); 
    Database.insert(newCampaign);
    Voting_Campaign__c newCampaign2 = 
            new Voting_Campaign__c(Name='TestCampaign2',Start_Date__c=System.today()+2, End_Date__c=System.today()+3, 
                                   Age_Range__c='46-55', Status__c='In progress', VotingLocation__c=newLocation.Id); 
    List<Voting_Campaign__c> campaignsToAdd = new List<Voting_Campaign__c> {newCampaign, newCampaign2};
    Database.insert(campaignsToAdd);
  }

  @isTest
  static void testDateValidationSuccess() {
    List<Voting_Location__c> newLocation = [
      select Id
      from Voting_Location__c
      where Name = 'Testowe'
    ];
    Voting_Campaign__c newCampaign = new Voting_Campaign__c(
      Start_Date__c = System.today(),
      End_Date__c = System.today() + 2,
      Age_Range__c = '46-55',
      Status__c = 'Planned',
      VotingLocation__c = newLocation[0].Id
    );
    Test.startTest();
    Database.SaveResult result = Database.insert(newCampaign);
    Test.stopTest();

    system.assert(result.isSuccess(), 'Dates are not valid!');
  }

  @isTest
  static void testDateValidationFailure() {
    List<Voting_Location__c> newLocation = [
      select Id
      from Voting_Location__c
      where Name = 'Testowe'
    ];

    Voting_Campaign__c newCampaign = new Voting_Campaign__c(
      Start_Date__c = System.today(),
      End_Date__c = System.today() - 2,
      Age_Range__c = '46-55',
      Status__c = 'Planned',
      VotingLocation__c = newLocation[0].Id
    );

    Test.startTest();
    Database.SaveResult result = Database.insert(newCampaign);
    Test.stopTest();

    system.assert(!result.isSuccess(), 'Dates are not valid!');
    system.assertEquals('Set correct dates!', result.getErrors()[0].getMessage());
  }

  @isTest
  static void testDateValidationSuccessBulk() {
    List<Voting_Location__c> newLocation = [
      select Id
      from Voting_Location__c
      where Name = 'Testowe'
    ];
    Voting_Campaign__c newCampaign1 = new Voting_Campaign__c(
      Start_Date__c = System.today(),
      End_Date__c = System.today() + 2,
      Age_Range__c = '46-55',
      Status__c = 'Planned',
      VotingLocation__c = newLocation[0].Id
    );
    Voting_Campaign__c newCampaign2 = new Voting_Campaign__c(
      Start_Date__c = System.today() + 1,
      End_Date__c = System.today() + 4,
      Age_Range__c = '46-55',
      Status__c = 'Planned',
      VotingLocation__c = newLocation[0].Id
    );
    List<Voting_Campaign__c> newCampaigns = new List<Voting_Campaign__c>{newCampaign1, newCampaign2};

    Test.startTest();
    List<Database.SaveResult> result = Database.insert(newCampaigns);
    Test.stopTest();

    for(Database.SaveResult res : result)
    {
      system.assert(res.isSuccess(), 'Dates are not valid!');
      system.assert(res.getErrors().size() == 0, 'Errors occured during Date validation');
    }

  }

  @isTest
  static void testDateValidationFailureBulk() {
    List<Voting_Location__c> newLocation = [
      select Id
      from Voting_Location__c
      where Name = 'Testowe'
    ];
    Voting_Campaign__c newCampaign1 = new Voting_Campaign__c(
      Start_Date__c = System.today(),
      End_Date__c = System.today() - 2,
      Age_Range__c = '46-55',
      Status__c = 'Planned',
      VotingLocation__c = newLocation[0].Id
    );
    Voting_Campaign__c newCampaign2 = new Voting_Campaign__c(
      Start_Date__c = System.today() - 1,
      End_Date__c = System.today() - 4,
      Age_Range__c = '46-55',
      Status__c = 'Planned',
      VotingLocation__c = newLocation[0].Id
    );
    List<Voting_Campaign__c> newCampaigns = new List<Voting_Campaign__c>{newCampaign1, newCampaign2};

    Test.startTest();
    List<Database.SaveResult> result = Database.insert(newCampaigns);
    Test.stopTest();

    for(Database.SaveResult res : result)
    {
      system.assert(!res.isSuccess(), 'Dates are not valid!');
      system.assert(res.getErrors().size() > 0, 'Errors occured during Date validation');
    }
  }
//------------------------------------------------------------------------------------
  @isTest
  static void testStatusChangeValidationSuccess() {
    Voting_Campaign__c campaign = [
      select Id, Status__c
      from Voting_Campaign__c
      where Name = 'TestCampaign'
      limit 1
    ];
    campaign.Status__c = 'Paused';
    Test.startTest();
    Database.SaveResult result = Database.update(campaign);
    Test.stopTest();
    system.assert(result.isSuccess(), 'Status cannot be changed to Planned status');
  }

  @isTest
  static void testStatusChangeValidationFailure() {
    Voting_Campaign__c campaign = [
      select Id, Status__c
      from Voting_Campaign__c
      where Name = 'TestCampaign'
      limit 1
    ];
    campaign.Status__c = 'Planned';
    Test.startTest();
    Database.SaveResult result = Database.update(campaign);
    Test.stopTest();
    system.assert(!result.isSuccess(), 'Status cannot be changed to Planned status');
    system.assert(result.getErrors().size() > 0, 'Errors occured during changing status');
  }

  @isTest
  static void testStatusChangeValidationSuccessBulk() {
    List<Voting_Campaign__c> campaigns = [
      select Id, Status__c
      from Voting_Campaign__c
      where (Name = 'TestCampaign' or Name = 'TestCampaign2')
    ];
    for(Voting_Campaign__c campaignToUpdate : campaigns)
    {
      campaignToUpdate.Status__c = 'Stopped';
    }
    Test.startTest();
    List<Database.SaveResult> result = Database.update(campaigns);
    Test.stopTest();
    for(Database.SaveResult res : result)
    {
      system.assert(res.isSuccess(), 'Status cannot be changed to Planned status');
      system.assert(res.getErrors().size() == 0, 'Errors occured during Status change validation');
    }
  }

  @isTest
  static void testStatusChangeValidationFailureBulk() {
    List<Voting_Campaign__c> campaigns = [
      select Id, Status__c
      from Voting_Campaign__c
      where (Name = 'TestCampaign' or Name = 'TestCampaign2')
    ];
    for(Voting_Campaign__c campaignToUpdate : campaigns)
    {
      campaignToUpdate.Status__c = 'Planned';
    }
    Test.startTest();
    List<Database.SaveResult> result = Database.update(campaigns);
    Test.stopTest();
    for(Database.SaveResult res : result)
    {
      system.assert(!res.isSuccess(), 'Status cannot be changed to Planned status');
      system.assert(res.getErrors().size() > 0, 'Errors occured during Status change validation');
    }
  }


  //-----------------------------------------------------------------------

  @isTest
  static void testNameValidationSuccess() {
    Voting_Location__c newLocation = [
      select Id
      from Voting_Location__c
      where Name = 'Testowe'
      limit 1
    ];
    Voting_Campaign__c newCampaign = new Voting_Campaign__c(
      Name = 'TestCampaign3',
      Start_Date__c = System.today() + 2,
      End_Date__c = System.today() + 3,
      Age_Range__c = '46-55',
      Status__c = 'In progress',
      VotingLocation__c = newLocation.Id
    );
    Test.startTest();
    Database.SaveResult result = Database.insert(newCampaign);
    Test.stopTest();

    system.assert(result.isSuccess(), 'Name of Campaign has to be unique!');
    system.assert(result.getErrors().size() == 0, 'Errors occured during Name validation');
  }

  @isTest
  static void testNameValidationFailure() {
    Voting_Location__c newLocation = [
      select Id
      from Voting_Location__c
      where Name = 'Testowe'
      limit 1
    ];
    Voting_Campaign__c newCampaign = new Voting_Campaign__c(
      Name = 'TestCampaign',
      Start_Date__c = System.today() + 2,
      End_Date__c = System.today() + 3,
      Age_Range__c = '46-55',
      Status__c = 'In progress',
      VotingLocation__c = newLocation.Id
    );
    Test.startTest();
    Database.SaveResult result = Database.insert(newCampaign);
    Test.stopTest();

    system.assert(!result.isSuccess(), 'Name of Campaign has to be unique!');
    system.assert(result.getErrors().size() > 0, 'Errors occured during Name validation');
    system.assertEquals('Campaign Name has to be unique!', result.getErrors()[0].getMessage());

  }

  @isTest
  static void testNameValidationSuccessBulk() {
    Voting_Location__c newLocation = [
      select Id
      from Voting_Location__c
      where Name = 'Testowe'
      limit 1
    ];
    Voting_Campaign__c newCampaign1 = new Voting_Campaign__c(
      Name = 'TestCampaignUnique001',
      Start_Date__c = System.today() + 2,
      End_Date__c = System.today() + 3,
      Age_Range__c = '46-55',
      Status__c = 'In progress',
      VotingLocation__c = newLocation.Id
    );
    Voting_Campaign__c newCampaign2 = new Voting_Campaign__c(
      Name = 'TestCampaignUnique002',
      Start_Date__c = System.today() + 2,
      End_Date__c = System.today() + 3,
      Age_Range__c = '46-55',
      Status__c = 'In progress',
      VotingLocation__c = newLocation.Id
    );
    List<Voting_Campaign__c> campaignsToCreate = new List<Voting_Campaign__c>{newCampaign1, newCampaign2};
    Test.startTest();
    List<Database.SaveResult> result = Database.insert(campaignsToCreate);
    Test.stopTest();

    for(Database.SaveResult res : result)
    {
      system.assert(res.isSuccess(), 'Name of Campaign has to be unique!');
      system.assert(res.getErrors().size()== 0, 'Errors occured during Name validation');
    }
  }

  @isTest
  static void testNameValidationFailureBulk() {
    Voting_Location__c newLocation = [
      select Id
      from Voting_Location__c
      where Name = 'Testowe'
      limit 1
    ];
    Voting_Campaign__c newCampaign1 = new Voting_Campaign__c(
      Name = 'TestCampaign',
      Start_Date__c = System.today() + 2,
      End_Date__c = System.today() + 3,
      Age_Range__c = '46-55',
      Status__c = 'In progress',
      VotingLocation__c = newLocation.Id
    );
    Voting_Campaign__c newCampaign2 = new Voting_Campaign__c(
      Name = 'TestCampaign',
      Start_Date__c = System.today() + 2,
      End_Date__c = System.today() + 3,
      Age_Range__c = '46-55',
      Status__c = 'In progress',
      VotingLocation__c = newLocation.Id
    );
    List<Voting_Campaign__c> campaignsToCreate = new List<Voting_Campaign__c>{newCampaign1, newCampaign2};
    Test.startTest();
    List<Database.SaveResult> result = Database.insert(campaignsToCreate);
    Test.stopTest();

    for(Database.SaveResult res : result)
    {
      system.assert(!res.isSuccess(), 'Name of Campaign has to be unique!');
      system.assert(res.getErrors().size() > 0, 'Errors occured during Name validation');
    }
    
  }
}
