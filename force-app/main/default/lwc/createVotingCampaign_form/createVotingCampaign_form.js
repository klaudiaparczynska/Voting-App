import { LightningElement } from 'lwc';
import VOTING_CAMPAIGN from "@salesforce/schema/Voting_Campaign__c";
import NAME from "@salesforce/schema/Voting_Campaign__c.Name";
import STATUS from "@salesforce/schema/Voting_Campaign__c.Status__c";
import START_DATE from "@salesforce/schema/Voting_Campaign__c.Start_Date__c";
import END_DATE from "@salesforce/schema/Voting_Campaign__c.End_Date__c";
import AGE_RANGE from "@salesforce/schema/Voting_Campaign__c.Age_Range__c";
import VOTING_LOCATION from "@salesforce/schema/Voting_Campaign__c.VotingLocation__c";


export default class CreateVotingCampaign_form extends LightningElement {
    Name=NAME;
    Status=STATUS;
    StartDate=START_DATE;
    EndDate=END_DATE;
    AgeRange=AGE_RANGE;
    VotingLocation=VOTING_LOCATION;
    VotingCamp=VOTING_CAMPAIGN;

    handleSuccess() {
        window.location.reload(true);
    }

}