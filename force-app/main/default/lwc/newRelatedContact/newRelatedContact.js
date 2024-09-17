import { LightningElement, track, api } from 'lwc';
import call from '@salesforce/apex/newRelatedContact.call';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const leadSourceOption = [
    { label: 'Choose Lead Source...', value: null },
    { label: 'Web', value: 'Web' },
    { label: 'Phone Inquiry', value: 'Phone Inquiry' },
    { label: 'Partner Referral', value: 'Partner Referral' },
    { label: 'Purchased List', value: 'Purchased List' },
    { label: 'Other', value: 'Other' }
];

export default class NewRelatedContact extends LightningElement {
    option = leadSourceOption;
    @api recordId;
    
    @track contactObj = {
        firstName: null,
        lastName: null,
        title: null,
        birthday: null,
        phone: null,
        email: null,
        leadSource: null,
        isDead: false       // Is_Dead__c (api name)
    }
    
    handleChange(e) {
        const inputName = e.target.name;
        const inputValue = e.target.value;
        
        if(e.target.type === 'checkbox') {
            this.contactObj = { ...this.contactObj, [inputName]: e.target.checked }; 
        } else {
            this.contactObj = { ...this.contactObj, [inputName]: inputValue }; 
        }


        console.log(e.target.type, e.target.name, e.target.type == 'checkbox', `value attr : ${inputValue} ${e.target.checked}`);
        console.log('Updated contactObj:', JSON.stringify(this.contactObj));
    }

    handleClickSubmit(e) {

        // basic bvalidation
        if(!this.contactObj.lastName || !this.contactObj.leadSource) {
            const event = new ShowToastEvent({
                title: 'Fill All the values',
                variant: 'Warning',
                message: `Please fill the required field.`,

            });
            this.dispatchEvent(event);
            return;
        }

        e.preventDefault();
        call({
            accountId: this.recordId,
            firstName: this.contactObj.firstName,
            lastName: this.contactObj.lastName,
            title: this.contactObj.title,
            birthday: this.contactObj.birthday,
            phone: this.contactObj.phone,
            email: this.contactObj.email,
            leadSource: this.contactObj.leadSource,
            isDead: this.contactObj.isDead
        })
        .then((contact) => {
            console.log('Contact Created Successfully ID:', contact.Id);
            const Id = contact.Id;
            const AccountId = contact.AccountId;
            const event = new ShowToastEvent({
                title: 'Success',
                variant: 'Success',
                message: `Record created Successfully with Id ${Id} and Related to Id ${AccountId}`,

            });
            this.dispatchEvent(event);
            
        })
        .catch((err) => {
            console.error('Error Creating Contact:', err);

            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'Error',
                message: `Something Went Wrong go figure out....`,

            });
            this.dispatchEvent(event);
        }).finally(() => {
            this.handleClickCancel(e);
        })
    }

    handleClickCancel(e) {
        this.contactObj = {
            firstName: null,
            lastName: null,
            title: null,
            birthday: null,
            phone: null,
            email: null,
            leadSource: null,
            isDead: false       // Is_Dead__c (api name)
        }
        // DOM reset
        // this.template.querySelectorAll('lightning-input').forEach(input => {
        //     if(input.type == 'checkbox') 
        //         input.checked = false;
        //     else 
        //         input.value = null;
        // });
        // this.template.querySelectorAll('lightning-combobox').forEach(input => {
        //     input.value = null;
        // });
        console.log('Form reset done..', JSON.stringify( this.contactObj));
    }
}
