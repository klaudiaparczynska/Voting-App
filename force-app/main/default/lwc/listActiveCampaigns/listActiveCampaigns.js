import { LightningElement,api,wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getActiveVotingCamp from '@salesforce/apex/ManageVotingCampaigns.getActiveVotingCamp';


const campaignDetails = [
    {
        label: 'Name', fieldName: 'LinkName', type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'Name'
            }
        }
    },
    {label: 'Start Date', fieldName: 'StartDate'},
    {label: 'End Date', fieldName: 'EndDate'},
];

export default class ListActiveCampaigns extends NavigationMixin(LightningElement) {
    @api recordId;
    columns = campaignDetails;
    @track campaigns;
    helpCampaigns;
    record;

    @wire(getActiveVotingCamp,{})  
    loadCamp({ error, data }){
        if (error) {
            console.log(error);
        } else if (data) {
            let helper = [];
            for(let i = 0; i < data.length; i++)
            {
                helper.push({
                    Id: data[i].Id,
                    Name: data[i].Name,
                    StartDate: data[i].Start_Date__c,
                    EndDate: data[i].End_Date__c,
                    Status: data[i].Status__c,
                    LinkName: '/' + data[i].Id
                });
            }
            this.campaigns = helper;
            this.helpCampaigns = helper;
            
        }
    }

    handleSearchChange( event ) {
        this.searchString = event.detail.value;
    }

    handleSearch( event ) {
        const searchKey = event.target.value.toLowerCase();
        if ( searchKey ) {
            this.campaigns = this.helpCampaigns;   
            if ( this.campaigns ) {
                let recs = [];
                for ( let rec of this.campaigns ) {
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
                this.campaigns = recs;
             }
        }  else {
            this.campaigns = this.helpCampaigns;
        }        
    }
}