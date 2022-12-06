import {LightningElement, wire, track, api} from 'lwc';
import getVotesperVoting from '@salesforce/apex/ChartData.getVotesperVoting';

export default class VotesPerVotingChart extends LightningElement {
  @track chartConfiguration;
  @api recordId;
   
  @wire(getVotesperVoting, {campaignId: '$recordId'})
  getVotes({error, data}) {
    if (error) {
      this.error = error;
      console.log('error => ' + JSON.stringify(error));
      this.chartConfiguration = undefined;
    } else if (data) {
      console.log(data);
      let chartData = [];
      let chartLabels = [];
      data.forEach(v => {
        chartData.push(v.expr0);
        chartLabels.push(v.Name);
      });
   
      this.chartConfiguration = {
       type: 'bar',
       data: {
        labels: chartLabels,
        datasets: [
         {
          label: 'Votes',
          barPercentage: 5,
          barThickness: 1,
          maxBarThickness: 2,
          minBarLength: 1,
          backgroundColor: "green",
          data: chartData,
         },
        ],
       },
       options: {},
      };
      console.log('data => ', data);
      this.error = undefined;
    }
  }
}

