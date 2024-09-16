import { LightningElement, wire } from 'lwc';
import call from '@salesforce/apex/fetchTopTenContacts.call';

const columns = [
    {label:"Last Name", fieldName:"LastName"},
    {label:"First Name", fieldName:"FirstName"},
    {label:"Phone", fieldName:"Phone", type:"Phone"},
    {label:"Email", fieldName:"Email"}
]
export default class DisplayTopRecords extends LightningElement {
    
    records = null;
    error = null;
    columns = columns;

    @wire(call)
    wiredContacts({data,  error}) {
        if(data) {
            console.log('OUTPUT : ',data);
            this.records = data;
        } else {
            this.error = error;
        }
    }
}