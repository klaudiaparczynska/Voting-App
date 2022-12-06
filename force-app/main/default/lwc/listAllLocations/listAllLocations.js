import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getLocations from '@salesforce/apex/ManageVotingLocations.getLocations';



const locationDetails= [
    {
        label: 'Name', fieldName: 'LinkName', type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'Name'
            }
        }
    },
    {label: 'Country', fieldName: 'Country'},
    {label: 'City', fieldName: 'City'},
    {label: 'Street', fieldName: 'Street'},
    {label: 'Postal Code', fieldName: 'PostalCode'},
];

export default class ListAllLocations extends NavigationMixin(LightningElement) {
    @track markers;
    columns=locationDetails;
    helpMarkers;

    @wire(getLocations,{})
    loadLocations({error, data}) {
        if(error) {
            console.log(error);
        }else if(data) {
            console.log(data);
            let helper = [];
            for(let i = 0; i < data.length; i++) {
                helper.push({
                    Id: data[i].Id,
                    Name: data[i].Name,
                    Country:  data[i].Country__c,
                    City: data[i].City__c,
                    Street: data[i].Street__c,
                    PostalCode: data[i].Postal_Code__c,
                    LinkName: '/' + data[i].Id
                })
            }
            this.markers = helper;
            this.helpMarkers = helper;
        }
    }


    handleSearchChange( event ) {
        this.searchString = event.detail.value;
    }

    handleSearch( event ) {
        const searchKey = event.target.value.toLowerCase();
        if ( searchKey ) {
            this.markers = this.helpMarkers;   
            if ( this.markers ) {
                let recs = [];
                for ( let rec of this.markers ) {
                    let valuesArray = Object.values( rec );
                    for ( let val of valuesArray ) {
                        let strVal = String( val );
                        if ( strVal ) {
                            if ( strVal.toLowerCase().includes( searchKey ) ) {
                                recs.push( rec );
                                break;
                            }
                        }
                    }
                }
                this.markers = recs;
             }
        }  else {
            this.markers = this.helpMarkers;
        }        
    }
}

