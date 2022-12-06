import { LightningElement,wire,api } from 'lwc';

import getVotingsWithoutAns from '@salesforce/apex/ManageVotings.getVotingsWithoutAns';
import getVotingOptions from '@salesforce/apex/ManageVotes.getVotingOptions';

import VOTE_OBJECT from '@salesforce/schema/Vote__c';
import CAMPAIGN_FIELD from '@salesforce/schema/Vote__c.Voting_Campaign__c';
import VOTING_FIELD from '@salesforce/schema/Vote__c.Voting__c';
import VOTE_FIELD from '@salesforce/schema/Vote__c.Voting_Question_Option__c';
import FEEDBACK_FIELD from '@salesforce/schema/Vote__c.Feedback__c';


 
export default class votingComponent extends LightningElement {
    @api recordId;
    votingOptions;
    selectedValue;
    options = [];
    votings = [];
    selectedVoting;

    addVoteForm=VOTE_OBJECT;
    campingField=CAMPAIGN_FIELD;
    votingField=VOTING_FIELD;
    voteField=VOTE_FIELD;
    feedbackField=FEEDBACK_FIELD;


    
    @wire(getVotingsWithoutAns,{recordId: '$recordId'}) 
    loadData({error, data}) {
        if(error) {
            console.log(error);
        } else if(data) {
            this.votings = data;
            console.log(this.votings);
            if(this.votings.length > 0) {
                this.selectedVoting = this.votings[0].Id;
                this.updateOptions(this.selectedVoting);
            }
        }
    }
    

    onValueSelection(event) {
        this.selectedValue = '';
        this.selectedVoting = event.target.value;
        this.updateOptions(this.selectedVoting)
    }

    updateOptions(selectedVoting) {
        getVotingOptions({
            votingId: selectedVoting
            })
            .then(optionsResult => {
                this.votingOptions = optionsResult;
                let optionsValues = [];
                for(let i = 0; i < optionsResult.length; i++) {
                    optionsValues.push({
                        label: optionsResult[i].Name,
                        value: optionsResult[i].Id
                    })
                }
                this.options = optionsValues;
            })
            .catch(error => {
                this.error = error;
            });
    }
    
    handleChange(event) {
        this.selectedValue = event.detail.value;
    }

    handleSuccess()  {
        this.selectedValue = '';
        window.location.reload();
    }
} 