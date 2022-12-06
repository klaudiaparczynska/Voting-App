public with sharing class VotesManager {
    
    public static void multipleVoteValidation(List<Vote__c> newRecords) {
        Set<String> voteNames = new Set<String>();
        Set<String> duplicateVotes = new Set<String>();
        for(Vote__c vote : newRecords) {
            voteNames.add(vote.Name);
        }
        for(Vote__c vote : [select Id, Name from Vote__c where Name in :voteNames]) {
            duplicateVotes.add(vote.Name);
        }
        for(Vote__c vote : newRecords) {
            if(duplicateVotes.contains(vote.Name)) {
                vote.Name.addError('Vote has already been submitted');
            }
        }
    }
}
