import { LightningElement, api} from 'lwc';

import VOTING from "@salesforce/schema/Voting_Question_Option__c.Voting__c";
import NAME from "@salesforce/schema/Voting_Question_Option__c.Name";
import VOTING_OPTION from "@salesforce/schema/Voting_Question_Option__c";


export default class CreateVotingOption extends LightningElement {
    @api recordId;

    Name=NAME;
    Voting=VOTING;
    VotingOption=VOTING_OPTION;


    handleSuccess() {
        window.location.reload(true);
    }
}