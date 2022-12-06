import { LightningElement, api, wire, track } from 'lwc';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';

const COUNTRY = 'Voting_Campaign__c.VotingLocation__r.Country__c';
const CITY = 'Voting_Campaign__c.VotingLocation__r.City__c';
const STREET = 'Voting_Campaign__c.VotingLocation__r.Street__c';
const POSTAL_CODE = 'Voting_Campaign__c.VotingLocation__r.Postal_Code__c';
const NAME = 'Voting_Campaign__c.Name';
const campaignFields = [
    NAME,
    COUNTRY,
    CITY,
    STREET,
    POSTAL_CODE
];

export default class LocationMap extends LightningElement {
  @api recordId;
  name;
  mapMarkers = [];

  @wire(getRecord, { recordId: '$recordId', fields: campaignFields })
  loadLoc({ error, data }) {
    if (error) {
    } else if (data) {
      this.name =  getFieldValue(data, NAME);
      const Country = getFieldValue(data, COUNTRY);
      const City = getFieldValue(data, CITY);
      const PostalCode = getFieldValue(data, POSTAL_CODE);
      const Street = getFieldValue(data, STREET);
      const State = '';
      
      this.mapMarkers = [{
        location: { City, Country, PostalCode, State, Street},
        title: 'Location',
        description: `Country: ${Country}`
      }];
    }
  }
    
    get generateTitle(){
        return (this.name) ?  `${this.name}'s location` : `${this.name}'s location`;   
  }
  
}