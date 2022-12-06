import { LightningElement,api,wire, track } from 'lwc';
import getVotingOptions from '@salesforce/apex/ManageVotes.getVotingOptions';

const details = [
    //{label: 'Id', fieldName: 'Id'},
    {label: 'Name', fieldName: 'Name'},
];


export default class ListVotingOptions extends LightningElement {
    @api recordId; 
    columns = details;
    @track options;
    helpOptions;

    @wire(getVotingOptions, {votingId: '$recordId'}) 
    loadOptions({error, data}){
        if (error) {
            console.log(error);
        } else if (data) {
            let helper = [];
            for(let i = 0; i < data.length; i++)
            {
                helper.push({
                    //Id: data[i].Id,
                    Name: data[i].Name
                })
            }
            this.options=helper;
            this.helpOptions=helper;
        }
    }

    handleSearchChange( event ) {
        this.searchString = event.detail.value;
    }

    handleSearch( event ) {
        const searchKey = event.target.value.toLowerCase();
        if ( searchKey ) {
            this.options = this.helpOptions;   
            if ( this.options ) {
                let recs = [];
                for ( let rec of this.options ) {
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
                this.options = recs;
             }
 
        }  else {

            this.options = this.helpOptions;
        }        
    }
    
}