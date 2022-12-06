import { LightningElement,wire, api} from 'lwc';
//importing the Chart library from Static resources
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//importing the apex method.
import getVotes from '@salesforce/apex/ChartData.getVotes';
export default class VotingDonutChart extends LightningElement {
  @api recordId;

  @wire(getVotes, {votingId: '$recordId'})
  results({error,data})
  {
    if(data)
    {
        for(let i = 0; i < data.length; i++)
        {
            this.updateChart(data[i].expr0,data[i].Name);
        }
        this.error=undefined;
    }
    else if(error)
    {
      this.error = error;
      this.accounts = undefined;
    }
  }


  chart;
  chartjsInitialized = false;
  config={
    type : 'doughnut',
    data :{
    datasets :[{
      data: [],
      backgroundColor :[
          'rgb(41, 52, 98)',
          'rgb(242, 76, 76)',
          'rgb(236, 155, 59)',
          'rgb(247, 215, 22)',
      ],
      label:'Votes'
    }],
    labels:[]
    },
    options: {
        responsive : true,
      legend : {
          position :'right'
      },
      animation:{
        animateScale: true,
        animateRotate : true
      },
    }
  };

  renderedCallback()
  {
    if(this.chartjsInitialized)
    {
      return;
    }
    this.chartjsInitialized = true;
    Promise.all([
      loadScript(this,chartjs)
    ]).then(() =>{
      const ctx = this.template.querySelector('canvas.donut')
      .getContext('2d');
      this.chart = new window.Chart(ctx, this.config);
    })
    .catch(error =>{
      this.dispatchEvent(
        new ShowToastEvent({
          title : 'Error loading ChartJS',
          message : error.message,
          variant : 'error',
        }),
      );
    });
  }
  updateChart(count,label)
  {
    this.chart.data.labels.push(label);
    this.chart.data.datasets.forEach((dataset) => {
      dataset.data.push(count);
    });
    this.chart.update();
  }
}