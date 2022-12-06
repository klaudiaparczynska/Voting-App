import { LightningElement, api, wire } from 'lwc';
import getLocationFromLocationId from '@salesforce/apex/ManageVotingLocations.getLocationFromLocationId';


export default class MapVoting_Locations extends LightningElement {
    @api recordId;
    mapMarkers;

    @wire(getLocationFromLocationId,{locationId: '$recordId'})  
    loadlocation({ error, data }){
        if (error) {
            console.log(error);
        } else if (data) {
            let Country = data[0].Country__c;
            let City = data[0].City__c;
            let Street = data[0].Street__c;
            let Postalcode = data[0].Postal_Code__c;
            let State = '';

            this.mapMarkers = [{
                location: { City, Country, Postalcode, State, Street},
                title: '',
                description: `Country: ${Country}`
              }];
        }
    }


}
