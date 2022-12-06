import {LightningElement, wire, track, api} from 'lwc';
import getVotes from '@salesforce/apex/ChartData.getVotes';

export default class VotingBarChart extends LightningElement {
 @track chartConfiguration;
 @api recordId;
 count = 0;

 @wire(getVotes, {votingId: '$recordId'})
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
      this.count += v.expr0;
   });

   this.chartConfiguration = {
    type: 'bar',
    data: {
     labels: chartLabels,
     datasets: [
      {
       label: 'Votes',
       barPercentage: 5,
       barThickness: 3,
       maxBarThickness: 4,
       minBarLength: 2,
       backgroundColor: "blue",
       data: chartData,
      },
     ],
    },
    options: {
    },
   };
   console.log('data => ', data);
   this.error = undefined;
  }
 }
}