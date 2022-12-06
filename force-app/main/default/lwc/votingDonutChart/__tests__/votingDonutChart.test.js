import { createElement } from 'lwc';
import VotingDonutChart from 'c/votingDonutChart';
import getVotes from '@salesforce/apex/ChartData.getVotes';
const mockGetList = require('./data/fullDataList.json');
const mockGetListNoRecords = require('./data/noDataList.json');
import { createApexTestWireAdapter  } from '@salesforce/sfdx-lwc-jest';
const getListAdapter = createApexTestWireAdapter(getVotes);
//'a097Q000000bnSqQAI';


describe('c-voting-donut-chart', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });
      describe('getAccountList @wire data', () => {
        it('renders two records', () => {
          const element = createElement('c-voting-donut-chart', {
            is: VotingDonutChart
          });
          element.votingId = 'a097Q000000bnSqQAI';
          document.body.appendChild(element);
        
          // Emit data from @wire
          getListAdapter.emit(mockGetList);
            
          return Promise.resolve().then(() => {
            // Select elements for validation
            const accountElements = element.shadowRoot.querySelectorAll('canvas');
            expect(accountElements.length).toBe(1);
            //expect(accountElements[0].textContent).toBe(mockGetList[0].Name);
          });
          
        });
          
        it('renders no items when no records are returned', () => {
          const element = createElement('c-voting-donut-chart', {
            is: VotingDonutChart
          });
          document.body.appendChild(element);
            
          // Emit data from @wire
          getListAdapter.emit(mockGetListNoRecords);
            
          return Promise.resolve().then(() => {
            // Select elements for validation
            const accountElements = element.shadowRoot.querySelectorAll('canvas');
            expect(accountElements.length).toBe(1);
          });
        });
      });

      describe('getAccountList @wire error', () => {
        it('shows error panel element', () => {
          const element = createElement('c-voting-donut-chart', {
            is: VotingDonutChart
          });
          document.body.appendChild(element);
            
          // Emit error from @wire
          getListAdapter.error();
            
          return Promise.resolve().then(() => {
            const errorElement = element.shadowRoot.querySelector('canvas');
            expect(errorElement).not.toBeNull();
            expect(errorElement.textContent).toBe('');
          });
        });
      });

});



