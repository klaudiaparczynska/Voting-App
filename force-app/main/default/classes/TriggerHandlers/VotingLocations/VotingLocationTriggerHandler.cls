public with sharing class VotingLocationTriggerHandler extends TriggerHandler {
    public VotingLocationTriggerHandler(){
        super('Voting_Location__c');
    }
        public override void beforeInsert(List<SObject> newRecords) {
            VotingLocationManager.validateUniqueness(newRecords);
        }
}
