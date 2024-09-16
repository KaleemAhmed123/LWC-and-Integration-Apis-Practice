import { LightningElement } from 'lwc';

// 2. Create a LWC which should display Contact records depending on following filters:
//    a. FirstName
//    b. LastName
//    c. Email
//    d. Number of Records to be displayed
//    PS: Please note by default latest 10 records should be displayed


export default class ContactRecordWithFilters extends LightningElement {
    firstName = null;
    lastName = null;;
    email = null;
    numOfRecords = 10;
}