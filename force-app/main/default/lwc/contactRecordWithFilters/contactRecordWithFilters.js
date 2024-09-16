import { LightningElement, wire, track } from 'lwc';
import call from '@salesforce/apex/contactRecordsWithFilters.call';

const columns = [
    {label:"Last Name", fieldName:"LastName"},
    {label:"First Name", fieldName:"FirstName"},
    {label:"Email", fieldName:"Email"}
];

export default class ContactRecordWithFilters extends LightningElement {
    empty = true;
    errorBool = false;
    columns = columns;
    records = null;

    @track contactObj = {
        firstName: null,
        lastName: null,
        email: null,
        numOfRecords: 10 
    };

    // $ to make parameter as reactive
    @wire(call, 
        {firstName: '$contactObj.firstName', 
        lastName: '$contactObj.lastName',
        email: '$contactObj.email',
        numOfRecords: '$contactObj.numOfRecords'}
    ) 
    wiredContacts({data, error}) {
        if(data) {
            this.empty = (data.length === 0) ? true: false;
            this.records = data;
            this.errorBool = false;
            // console.log(data, "  ===>   ", this.records, this.empty);
        } 
        if(error) {
            this.records = null;
            this.errorBool = true;
        }
    }

    handleChange(e) {
        const name = e.target.name;
        const value = e.target.value;

        this.contactObj = { ...this.contactObj, [name]: value };

        console.log('Updated contactObj:', JSON.stringify(this.contactObj));
    }
}