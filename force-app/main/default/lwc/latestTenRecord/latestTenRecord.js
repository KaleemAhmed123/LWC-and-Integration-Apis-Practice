import { LightningElement, wire } from 'lwc';
import latestTenRecord from "@salesforce/apex/AccountLwcController.getLatestAccounts";
import getQueriesAccount from "@salesforce/apex/AccountLwcController.getQueriesAccount";

export default class LatestTenRecord extends LightningElement {
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text'  },
        { label: 'Owner Name', fieldName: 'Owner.Name', type: 'text' }
    ];
    records;
    query
    @wire(latestTenRecord)
    wiredData1({data, error}) {
        this.records = data;
        console.log(data);
        
    }
    
    @wire(getQueriesAccount, {query: '$query'})
    wiredData2({data, error}) {
        this.records = data;
    }

    updateQuery(e) {
        this.query = e.target.value;
        console.log(this.query);
        
    }
}