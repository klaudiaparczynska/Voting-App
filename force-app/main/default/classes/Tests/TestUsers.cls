@isTest
private with sharing class TestUsers {
    @isTest
    static void testAssignUserToGroupSuccess(){
        String uniqueUserName = 'Voter' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [select Id from Profile where Name='Voter'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, Age_Range__c='0-18',
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);
         Test.startTest();
         Database.SaveResult result = Database.insert(u);
         Test.stopTest();
         GroupMember validation =  [select Id from GroupMember where UserOrGroupId = :u.Id];
         system.assert(result.isSuccess(), 'User Assignment did not run correctly!');
         system.assert(result.getErrors().size() == 0, 'Errors occured during User assign validation');
         system.assertNotEquals(null, validation, 'User is not assigned');
    }
    @isTest
    static void testAssignUserToGroupFailure(){
        String uniqueUserName = 'Conf' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [select Id from Profile where Name='Configurator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, Age_Range__c='0-18',
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);
         Test.startTest();
         Database.SaveResult result = Database.insert(u);
         Test.stopTest();
         GroupMember validation =  [select Id from GroupMember where UserOrGroupId = :u.Id];
         system.assert(!result.isSuccess(), 'User Assignment did not run correctly!');
         system.assert(result.getErrors().size() > 0, 'Errors occured during User assign validation');
         system.assertEquals(null, validation, 'User is not assigned');
    }
    @isTest
    static void testAssignUserToGroupSuccessBulk(){
        Profile mod = [select Id from Profile where Name='Moderator'];
        User firstUser = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = mod.Id, Age_Range__c='55+',
        TimeZoneSidKey='America/Los_Angeles',
         UserName= 'Moderator' + DateTime.now().getTime() + '@testorg.com');

        Profile analyst = [select Id from Profile where Name='Analyst'];
        User secondUser = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = analyst.Id, Age_Range__c='0-18',
        TimeZoneSidKey='America/Los_Angeles',
        UserName='Analyst' + DateTime.now().getTime() + '@testorg.com');

        List<User> usersToAdd = new List<User>{firstUser, secondUser};
        Test.startTest();
        List<Database.SaveResult> result = Database.insert(usersToAdd);
        Test.stopTest();
        for(Database.SaveResult res : result) {
            system.assert(res.isSuccess(), 'User Assignment did not run correctly!');
            system.assert(res.getErrors().size() == 0, 'Errors occured during User assign validation');
        }

    }
    @isTest
    static void testAssignUserToGroupFailureBulk(){
        Profile conf = [select Id from Profile where Name='Configurator'];
        User firstUser = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = conf.Id, Age_Range__c='55+',
        TimeZoneSidKey='America/Los_Angeles',
         UserName='Configurator' + DateTime.now().getTime() + '@testorg.com');

         User secondUser = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = conf.Id, Age_Range__c='46-55',
        TimeZoneSidKey='America/Los_Angeles',
         UserName='Configurator2' + DateTime.now().getTime() + '@testorg.com');
         
        List<User> usersToAdd = new List<User>{firstUser, secondUser};
        Test.startTest();
        List<Database.SaveResult> result = Database.insert(usersToAdd);
        Test.stopTest();
        for(Database.SaveResult res : result) {
            system.assert(!res.isSuccess(), 'User Assignment did not run correctly!');
            system.assert(res.getErrors().size() > 0, 'Errors occured during User assign validation');
        }
    }

    //---------------------------------------------------------------------------------------

    @isTest
    static void testDeleteUserFromGroupSuccess(){
        Profile voter = [select Id from Profile where Name='Voter'];
        User userToEdit = [select Name, Age_Range__c from User where ProfileId = :voter.Id limit 1];
        List<GroupMember> previousGroup = [select GroupId from GroupMember where UserOrGroupId = :userToEdit.Id];
        userToEdit.Age_Range__c = '26-35';
        Test.startTest();
        Database.SaveResult result = Database.update(userToEdit);
        Test.stopTest();
        List<GroupMember> actualGroup = [select GroupId from GroupMember where UserOrGroupId = :userToEdit.Id];
        system.assert(result.isSuccess(), 'User has not been deleted from group');
        system.assertNotEquals(previousGroup, actualGroup, 'User not reassigned to other group');
    }

    @isTest
    static void testDeleteUserFromGroupFailure(){
        Profile conf = [select Id from Profile where Name='Configurator'];
        User userToEdit = [select Name, Age_Range__c from User where ProfileId = :conf.Id limit 1];
        List<GroupMember> previousGroup = [select GroupId from GroupMember where UserOrGroupId = :userToEdit.Id];
        if(userToEdit.Age_Range__c != '55+') {
            userToEdit.Age_Range__c = '55+';
        } else {
            userToEdit.Age_Range__c = '46-55';
        }
        Test.startTest();
        Database.SaveResult result = Database.update(userToEdit);
        Test.stopTest();
        List<GroupMember> actualGroup = [select GroupId from GroupMember where UserOrGroupId = :userToEdit.Id];

        system.assert(!result.isSuccess(), 'User has not been deleted from group');
        system.assertEquals(previousGroup, actualGroup, 'User not reassigned to other group');
    }

    @isTest
    static void testDeleteUserFromGroupSuccessBulk(){
        Profile voter = [select Id from Profile where Name='Voter'];
        Profile mod = [select Id from Profile where Name='Moderator'];
        List<User> userToEdit = [select Name, Age_Range__c from User where (ProfileId = :voter.Id or ProfileId = :mod.Id) limit 2];
        List<GroupMember> previousGroup = [select GroupId from GroupMember where UserOrGroupId in :userToEdit];
        for(User user : userToEdit) {
            if(user.Age_Range__c != '19-25') {
                user.Age_Range__c = '19-25';
            } else {
                user.Age_Range__c = '0-18';
            }
        }
        Test.startTest();
        List<Database.SaveResult> result = Database.update(userToEdit);
        Test.stopTest();
        List<GroupMember> actualGroup = [select GroupId from GroupMember where UserOrGroupId in :userToEdit];
        for(Database.SaveResult res : result) {
            system.assert(res.isSuccess(), 'User has not been deleted from group');
        }
        system.assertNotEquals(previousGroup, actualGroup, 'User not reassigned to other group');
    }

    @isTest
    static void testDeleteUserFromGroupFailureBulk(){
        Profile conf = [select Id from Profile where Name='Configurator'];
        Profile sta = [select Id from Profile where Name='Standard User'];
        List<User> userToEdit = [select Name, Age_Range__c from User where (ProfileId = :conf.Id or ProfileId = :sta.Id) limit 2];
        List<GroupMember> previousGroup = [select GroupId from GroupMember where UserOrGroupId in :userToEdit];
        for(User user : userToEdit) {
            if(user.Age_Range__c != '55+') {
                user.Age_Range__c = '55+';
            } else {
                user.Age_Range__c = '46-55';
            }
        }
        Test.startTest();
        List<Database.SaveResult> result = Database.update(userToEdit);
        Test.stopTest();
        List<GroupMember> actualGroup = [select GroupId from GroupMember where UserOrGroupId in :userToEdit];
        for(Database.SaveResult res : result) {
            system.assert(!res.isSuccess(), 'User has not been deleted from group');
        }
        system.assertEquals(previousGroup, actualGroup, 'User not reassigned to other group');
    }


}
