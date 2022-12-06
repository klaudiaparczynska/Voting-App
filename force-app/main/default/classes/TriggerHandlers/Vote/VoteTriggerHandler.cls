public with sharing class VoteTriggerHandler extends TriggerHandler{
    public VoteTriggerHandler() {
        super('Vote__c');

    }

    public override void beforeInsert(List<SObject> newRecords) {
        VotesManager.multipleVoteValidation(newRecords);
    }

}
