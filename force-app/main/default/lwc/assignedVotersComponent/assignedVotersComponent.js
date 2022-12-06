import { LightningElement, api, wire, track} from 'lwc';
import getGroupMembers from '@salesforce/apex/ManageUsers.getGroupMembers';

const columns = [
    {label: 'Id', fieldName: 'Id'},
    {label: 'Username', fieldName: 'Username'}
];


export default class AssignedVotersComponent extends LightningElement {
    @api recordId;
    username;

    columns = columns;
    
    @track usernames = [];
    @track moderators = [];
    @track analysists = [];

    @wire(getGroupMembers,{campaignId:'$recordId', groupName:'Voter'})
    loadUsernames({error, data}){
        if(error){
            console.log(error);
        }
        else if (data){
            let un = [];
            for(let i = 0; i<data.length; i++){
                un.push({
                    Id: data[i].Id,
                    Username: data[i].Username
                });
            }
            this.usernames = un;
        }
    }


    @wire(getGroupMembers,{campaignId:'$recordId', groupName:'Moderator'})
    loadModerators({error, data}){
        if(error){
            console.log(error);
        }
        else if (data){
            let mod = [];
            for(let i = 0; i<data.length; i++){
                mod.push({
                    Id: data[i].Id,
                    Username: data[i].Username
                });
            }
            this.moderators = mod;
        }
    }

    @wire(getGroupMembers,{campaignId:'$recordId', groupName:'Analyst'})
    loadAnalysists({error, data}){
        if(error){
            console.log(error);
        }
        else if (data){
            let ana = [];
            for(let i = 0; i<data.length; i++){
                ana.push({
                    Id: data[i].Id,
                    Username: data[i].Username
                });
            }
            this.analysists = ana;
        }
    }


}