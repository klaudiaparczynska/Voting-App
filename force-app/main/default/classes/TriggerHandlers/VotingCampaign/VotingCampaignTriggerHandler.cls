public without sharing class VotingCampaignTriggerHandler extends TriggerHandler {
    public List<Voting_Campaign__c> newRecords = new List<Voting_Campaign__c>();
    public VotingCampaignTriggerHandler(){
        super('Voting_Campaign__c');
    }
        public override void beforeInsert(List<SObject> newRecords) {
            VotingCampaignsManager.nameValidation(newRecords);
            VotingCampaignsManager.dateValidation(newRecords);
        }
        public override void beforeUpdate(List<SObject> newRecords, Map<ID, SObject> newRecordMap, List<SObject> oldRecords,  Map<ID, SObject> oldRecordMap) {
            VotingCampaignsManager.statusChangeValidation(newRecords);
        }
        public override void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap) {
            
        }
        public override void afterUpdate(List<SObject> newRecords, Map<ID, SObject> newRecordMap, List<SObject> oldRecords,  Map<ID, SObject> oldRecordMap) {
            
        }
}
