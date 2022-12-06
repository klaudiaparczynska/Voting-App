public without sharing class UserManager {

    static final List<String> ALLOWEDPROFILES = new List<String> {'Voter', 'Moderator', 'Analyst'};

    public static void assignUserToGroup(List<User> newRecords) {
        Map<Id, Profile> profileNames =new Map<Id, Profile>([select Id, Name from Profile where Name in :ALLOWEDPROFILES]);
        Map<String, List<User>> groupsToUsers = new Map<String, List<User>>();
        List<groupMember> groupMembers = new List<groupMember>();

        for(User user : newRecords) {
            String groupName = '';
            if(!profileNames.containsKey(user.ProfileId)) {
                continue;
            }
            String formattedAge = user.Age_Range__c.remove('+').replace('-', '_');
            String profileName = profileNames.get(user.ProfileId).Name;
            if(profileName == 'Voter') {
                groupName = profileName+'_'+formattedAge;
            } else {
                if(Integer.valueOf(formattedAge.substring(0,1)) < 2) {
                    groupName = profileName+'_under_25';
                } else {
                    groupName = profileName+'_above_25';
                }
            }
            if(groupsToUsers.containsKey(groupName)) {
                List<User> listOfUsers = groupsToUsers.get(groupName);
                listOfUsers.add(user);
                groupsToUsers.put(groupName, listOfUsers);
            } else {
                groupsToUsers.put(groupName, new List<User>{user});
            }
        }

        for(Group userGroup : [select Id, Name from Group where Name in :groupsToUsers.keySet()]) {
            for(User usr : groupsToUsers.get(userGroup.Name)) {
                GroupMember gm = new GroupMember();
                gm.GroupId = userGroup.Id;
                gm.UserOrGroupId = usr.Id;
                groupMembers.add(gm);
            }
        }
        if(!groupMembers.isEmpty()) {
            insert groupMembers;
        }
    }


    public static void deleteUserFromGroup(List<User> oldRecords) {
        Map<Id, Profile> profileNames = new Map<Id, Profile>([select Id, Name from Profile where Name in :ALLOWEDPROFILES]);
        Map<String, List<User>> groupsToUsers = new Map<String, List<User>>();
        Map<Id, User> mapOfUsers = new Map<Id, User>();
        for(User user : oldRecords) {
            if(!profileNames.containsKey(user.ProfileId)) {
                continue;
            }
            mapOfUsers.put(user.Id, user);
        }
        List<User> takeProfile = [select Id, Name, Profile.Name from User where Id in :mapOfUsers.keySet()];
        for(User u : takeProfile) {
            String groupName = u.Name;
            User currentUser = mapOfUsers.get(u.Id);
            String formattedAge = currentUser.Age_Range__c.remove('+').replace('-', '_');
            if(u.Name == 'Voter') {
                groupName += '_'+formattedAge;
            } else {
                if(Integer.valueOf(formattedAge.substring(0,1)) < 2) {
                    groupName += + '_under_25';
                } else {
                    groupName += '_above_25';
                }
            }
            if(groupsToUsers.containsKey(groupName)) {
                List<User> lista = groupsToUsers.get(groupName);
                lista.add(currentUser);
                groupsToUsers.put(groupName, lista);
            } else {
                groupsToUsers.put(groupName, new List<User>{currentUser});
            }
        }
        List<Group> groups = [select Id, Name from Group where Group.Name in :groupsToUsers.keySet()];
        List<GroupMember> deleteUser = [select Id, UserOrGroupId, GroupId from GroupMember where UserOrGroupId in :mapOfUsers.keySet() and GroupId in :groups];
        if(!deleteUser.isEmpty()) {
            delete deleteUser;
        }
        
    }

}
