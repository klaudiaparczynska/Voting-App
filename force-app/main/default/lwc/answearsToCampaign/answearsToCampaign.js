import { LightningElement, wire, api } from 'lwc';
import getVotesFromCampaign from '@salesforce/apex/ManageVotes.getVotesFromCampaign';

const votesDetails = [
    //{label: 'Id', fieldName: 'Id'},
    {label: 'Voting', fieldName: 'Voting'},
    {label: 'Vote', fieldName: 'Vote'},
    //{ type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'right' }}
];

export default class AnswearsToCampaign extends LightningElement {
    @api recordId; 
    votes;
    columns=votesDetails;


    @wire(getVotesFromCampaign,{campaignId: '$recordId'}) 
    loadData({error, data}) {
        if(error) {
            console.log(error);
        } else if(data) {
            console.log(data);
            let helper = [];
            for(let i = 0; i < data.length; i++)
            {
                helper.push({
                    Id: data[i].Id,
                    Voting: data[i].Voting__r.Name,
                    Vote: data[i].Voting_Question_Option__r.Name
                });
            }
            this.votes = helper; 
        }
    }
}