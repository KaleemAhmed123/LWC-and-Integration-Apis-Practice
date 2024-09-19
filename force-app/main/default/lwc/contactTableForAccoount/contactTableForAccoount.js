import { LightningElement, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getUniqueAccount from "@salesforce/apex/getAccountsForSelect.getUniqueAccount";
import getRelatedContacts from "@salesforce/apex/getAccountsForSelect.getRelatedContacts";
const contactCols = [
  { label: "Last Name", fieldName: "LastName" },
  { label: "First Name", fieldName: "FirstName", type: "text" },
  { label: "Phone", fieldName: "Phone", type: "phone" },
  { label: "Parent Id", fieldName: "AccountId", type: "text" },
  { label: "Record Owner", fieldName: "Contact.Owner.Name", type: "text" }
];

// LastName, FirstName, Phone, AccountId, Account.Name

export default class ContactTableForAccount extends LightningElement {
  @track accList = [];
  @track relatedContacts = [];
  selectedAccountId = null;
  options = [];
  columns = contactCols;

  showStdTable = false;
  showCustomTable = false;
  showBtns = false;

  @wire(getUniqueAccount)
  wiredAccount({ error, data }) {
    if (data) {
      this.accList = JSON.parse(JSON.stringify(data));
      console.log("Data", this.accList);

      const temp = [{ label: "Choose Account", value: null }];
      this.accList.forEach((account) => {
        temp.push({ label: account.Name, value: account.Id });
      });

      this.options = temp;
      console.log("Options .....", JSON.stringify(this.options));
    } else if (error) {
      console.log("Error:", error);
    }
  }

  handleChange(e) {
    e.preventDefault();
    this.selectedAccountId = e.target.value;
    console.log(e.target.value);

    if (this.selectedAccountId == null) {
      this.showBtns = false;
      this.showStdTable = false;
      this.showCustomTable = false;
      return;
    }

    if (this.selectedAccountId != null) {
      this.showBtns = true;
      getRelatedContacts({ accId: this.selectedAccountId }).then((data) => {
        this.relatedContacts = data;
        if (this.relatedContacts.length === 0) {
          const event = new ShowToastEvent({
            title: "No related contacts found",
            variant: "Warning",
            message: `No related contacts found.`
          });
          this.dispatchEvent(event);

          // reset table
          this.showBtns = false;
          this.showStdTable = false;
          this.showCustomTable = false;

          return;
        }

        this.showStdTable = false;
        this.showCustomTable = false;

        console.log(JSON.stringify(this.selectedAccountId));
      });
    }
  }

  handleClick(e) {
    if (e.target.name === "stdTable") {
      this.showStdTable = true;
      this.showCustomTable = false;
    } else {
      this.showStdTable = false;
      this.showCustomTable = true;
    }
  }
}
