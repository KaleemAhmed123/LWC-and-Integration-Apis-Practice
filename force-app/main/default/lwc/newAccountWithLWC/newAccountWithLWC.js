import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import call from '@salesforce/apex/newAccountWithLWC.call';

const RatingOption = [
    { label: 'Choose Rating...', value: null },
    { label: 'Hot', value: 'Hot' },
    { label: 'Warm', value: 'Warm' },
    { label: 'Cold', value: 'Cold' }
];

export default class newAccountWithLWC extends LightningElement {
    option = RatingOption;

    @track accObj = {
        name: null,
        phone: null,
        website: null,
        lastPurchaseDate: null,
        isIntel: false,
        rating: null
    }

    handleChange(e) {
        const inputName = e.target.name;
        const inputValue = e.target.value;
        
        if (inputName === 'isIntel') {
            this.accObj = { ...this.accObj, [inputName]: e.target.checked }; 
        } else {
            this.accObj = { ...this.accObj, [inputName]: inputValue };
        }

        console.log('Updated accObj:', JSON.stringify(this.accObj));
    }

    handleClickSubmit(e) {
        e.preventDefault();
        call({
            name: this.accObj.name,
            phone: this.accObj.phone,
            website: this.accObj.website,
            lastPurchaseDate: this.accObj.lastPurchaseDate,
            rating: this.accObj.rating,
            isIntel: this.accObj.isIntel
        })
        .then((account) => {
            console.log('Account Created Successfully ID:', account.Id);
            const Id = account.Id;
            const event = new ShowToastEvent({
                title: 'Success',
                variant: 'Success',
                message: `Record created Successfully with Id ${Id}`,

            });
            this.dispatchEvent(event);
            
        })
        .catch((err) => {
            console.error('Error Creating Account:', err);

            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'Error',
                message: `Something Went Wrong....`,

            });
            this.dispatchEvent(event);
        }).finally(() => {
            this.handleClickCancel(e);
        })
    }

    handleClickCancel(e) {
        this.accObj = {
            name: null,
            phone: null,
            website: null,
            lastPurchaseDate: null,
            isIntel: false,
            rating: null
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
        console.log('Form reset done..');
    }
}
