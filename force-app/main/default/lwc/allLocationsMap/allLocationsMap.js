import { LightningElement, wire} from 'lwc';
import getLocations from '@salesforce/apex/ManageVotingLocations.getLocations';

export default class AllLocationsMap extends LightningElement {

    markers=[];

    @wire(getLocations,{})
    loadLocations({error, data}) {
        if(error) {
            console.log(error);
        }else if(data) {
            console.log(data);
            let helper = [];
            for(let i = 0; i < data.length; i++) {
                let Country =  data[i].Country__c;
                let City = data[i].City__c;
                let PostalCode = data[i].Postal_Code__c;
                let Street = data[i].Street__c;
                let State = '';
                
                helper.push({
                    location: { City, Country, PostalCode, State, Street},
                    title: `${Country}, ${City}`,
                    description: `${Country}, ${City}, ${Street} ${PostalCode}`
                })
            }
            this.markers = helper;
        }
    }
}
