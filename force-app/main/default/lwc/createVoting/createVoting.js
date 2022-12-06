import { LightningElement, api} from 'lwc';

import VOTING_CAMPAIGN from "@salesforce/schema/Voting__c.Voting_Campaign__c";
import NAME from "@salesforce/schema/Voting__c.Name";
import TYPE from "@salesforce/schema/Voting__c.Voting_Type__c";
import VOTING from "@salesforce/schema/Voting__c";


export default class CreateVoting extends LightningElement {
    @api recordId;

    Name=NAME;
    Type=TYPE;
    VotingCampaign=VOTING_CAMPAIGN;
    Voting=VOTING;


    handleSuccess() {
        window.location.reload(true);
    }
}
