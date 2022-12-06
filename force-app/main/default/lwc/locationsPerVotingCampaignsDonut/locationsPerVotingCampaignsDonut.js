import { LightningElement,wire,api} from 'lwc';

import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import locationsPerVotingCampaigns from '@salesforce/apex/ChartData.locationsPerVotingCampaigns';

export default class LocationsPerVotingCampaignsDonut extends LightningElement {
   @api recordId;
   chartColors;

   @wire (locationsPerVotingCampaigns) 
   results({error,data})
   {
      if(data) {
         for(let i = 0; i < data.length; i++) {
               this.updateChart(data[i].expr0,data[i].Name);
         }
         this.error=undefined;
         this.chartColors = this.generateColors(data.length);
        console.log(this.chartColors);
      }
      else if(error) {
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
               'rgb(188,236,224)',
               'rgb(54,238,224)',
               'rgb(246,82,160)',
               'rgb(76,82,112)',
               'rgb(255,112,119)',
               'rgb(255,233,228)',
               'rgb(255,176,103)',
               'rgb(172,238,243)',
            ],
            label:'Locations'
         }],
         labels:[],
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
   renderedCallback(){
      if(this.chartjsInitialized){
         return;
      }
      this.chartjsInitialized = true;
      Promise.all([
         loadScript(this,chartjs)
      ]).then(() =>{
         const ctx = this.template.querySelector('canvas.donut').getContext('2d');
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
   updateChart(count,label) {
      this.chart.data.labels.push(label);
      this.chart.data.datasets.forEach((dataset) => {
         dataset.data.push(count);
      });
      this.chart.update();
   }

}

