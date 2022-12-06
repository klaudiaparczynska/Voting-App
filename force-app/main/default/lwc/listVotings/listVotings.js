import { LightningElement,api,wire, track } from 'lwc';
import getList from '@salesforce/apex/ManageVotings.getList';


const details = [
    //{label: 'Id', fieldName: 'Id'},
    {
        label: 'Name', fieldName: 'LinkName', type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'Name'
            }
        }
    },
    {label: 'Type', fieldName: 'Type'},
];

export default class ListVotings extends LightningElement {
    @api recordId; 
    columns = details;
    @track voting;
    helpVoting;
    recordPageUrl;


    @wire(getList, {recordId: '$recordId'})
    loadVotings({error, data}){
        if (error) {
            console.log(error);
        } else if (data) {
            let helper = [];
            for(let i = 0; i < data.length; i++)
            {
                helper.push({
                    Id: data[i].Id,
                    Name: data[i].Name,
                    Type: data[i].Voting_Type__c,
                    LinkName: '/' + data[i].Id
                })
            }
            this.voting=helper;
            this.helpVoting=helper;
        }
    }

    handleSearchChange( event ) {
        this.searchString = event.detail.value;
    }

    handleSearch( event ) {
        const searchKey = event.target.value.toLowerCase();
        if ( searchKey ) {
            this.voting = this.helpVoting;   
            if ( this.voting ) {
                let recs = [];
                for ( let rec of this.voting ) {
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
                this.voting = recs;
             }
        }  else {
            this.voting = this.helpVoting;
        }        
    }
   
    
}