public with sharing class ManageUsers {
    
    @AuraEnabled(cacheable=true)
    public static List<User> getGroupMembers(String campaignId, String groupName)
    {
        Id formattedCampaignId = Id.valueOf(campaignId);
        String formattedGroupName;
        String ageRange;
        for(Voting_Campaign__c camp : [select Age_Range__c from Voting_Campaign__c where Voting_Campaign__c.Id = :formattedCampaignId])
        {
            ageRange = camp.Age_Range__c;
        }

        if(groupName == 'Voter') {
            String formattedAge = ageRange.remove('+').replace('-', '_');
            formattedGroupName = (groupName+'_'+formattedAge);
        }
        else if(groupName == 'Moderator' || groupName == 'Analyst') {
            if(Integer.valueOf(ageRange.substring(0,1)) < 2) {
                formattedGroupName = (groupName+'_under_25');
            }
            else formattedGroupName = (groupName+'_above_25');
        }
        List<User> allGroupMembers = [select Username from User where isActive = TRUE and Id in 
            (select UserOrGroupId from GroupMember where Group.DeveloperName = :formattedGroupName)];
        return allGroupMembers;
    }
}