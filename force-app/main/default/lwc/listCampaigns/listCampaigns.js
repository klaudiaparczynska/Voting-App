import { LightningElement,api,wire, track } from 'lwc';
import getVotingCamp from '@salesforce/apex/ManageVotingCampaigns.getVotingCamp';

const campaignDetails = [
    //{label: 'Id', fieldName: 'Id'},
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
    {label: 'Status', fieldName: 'Status'},
    {label: 'Age Range', fieldName: 'AgeRange'},
];

export default class ListCampaigns extends LightningElement {
    @api recordId;
    columns = campaignDetails;
    @track campaigns;
    helpCamapigns;
    record;

    @wire(getVotingCamp,{})  
    loadCamp({ error, data }){
        if (error) {
            console.log(error);
        } else if (data) {
            console.log(data);
            let helper = [];
            for(let i = 0; i < data.length; i++) {
                helper.push({
                    Id: data[i].Id,
                    Name: data[i].Name,
                    StartDate: data[i].Start_Date__c,
                    EndDate: data[i].End_Date__c,
                    Status: data[i].Status__c,
                    AgeRange: data[i].Age_Range__c,
                    LinkName: '/' + data[i].Id
                });
            }
            this.campaigns = helper;
            this.helpCamapigns = helper;
        }
    }

    handleSearchChange( event ) {
        this.searchString = event.detail.value;
        console.log( 'Updated Search String is ' + this.searchString );
    }

    handleSearch( event ) {
        const searchKey = event.target.value.toLowerCase();
        if ( searchKey ) {
            this.campaigns = this.helpCamapigns;   
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

            this.campaigns = this.helpCamapigns;
        }        

    }
   
}