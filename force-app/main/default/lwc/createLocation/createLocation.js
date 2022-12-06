import { LightningElement, track } from 'lwc';
import VOTING_LOCATION from "@salesforce/schema/Voting_Location__c";
import NAME from "@salesforce/schema/Voting_Location__c.Name";
import COUNTRY from "@salesforce/schema/Voting_Location__c.Country__c";
import CITY from "@salesforce/schema/Voting_Location__c.City__c";
import STREET from "@salesforce/schema/Voting_Location__c.Street__c";
import POSTAL_CODE from "@salesforce/schema/Voting_Location__c.Postal_Code__c";

export default class CreateLocation extends LightningElement {

    @track mapMarkers;
    @track showMap = false;

    VotingLoc=VOTING_LOCATION;
    Name=NAME;
    Country=COUNTRY;
    City=CITY;
    Street=STREET;
    PostalCode=POSTAL_CODE;

    handleSuccess() {
        window.location.reload(true);
        
    }
}