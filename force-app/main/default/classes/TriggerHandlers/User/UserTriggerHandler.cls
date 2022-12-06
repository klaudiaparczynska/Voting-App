public with sharing class UserTriggerHandler extends TriggerHandler {
    public UserTriggerHandler(){
        super('User');
    }

        public override void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap) {
            UserManager.assignUserToGroup(newRecords);
        }
        public override void afterUpdate(List<SObject> newRecords, Map<ID, SObject> newRecordMap, List<SObject> oldRecords,  Map<ID, SObject> oldRecordMap) {
            UserManager.deleteUserFromGroup(oldRecords);
            UserManager.assignUserToGroup(newRecords);
        }
}