/* eslint-disable no-unused-vars */
import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createRecords from "@salesforce/apex/ThreeRecordAtOnceLWC.call";
import { NavigationMixin } from "lightning/navigation";

export default class AccountContactOpportunityComponent extends NavigationMixin(
  LightningElement
) {
  accObj = {
    name: null,
    phone: null,
    desc: null
  };
  conObj = {
    firstName: null,
    lastName: null,
    email: null
  };
  oppObj = {
    name: null,
    stage: null,
    closeDate: null
  };

  clearForm(e) {
    this.accObj = {
      name: null,
      phone: null,
      desc: null
    };
    this.conObj = {
      firstName: null,
      lastName: null,
      email: null
    };
    this.oppObj = {
      name: null,
      stage: null,
      closeDate: null
    };
  }

  handleChange(e) {
    const objType = e.target.dataset.obj; // 'accObj', 'conObj'...
    const name = e.target.name;
    const value = e.target.value;

    this[objType] = { ...this[objType], [name]: value };

    console.log("Updated Object: ", JSON.stringify(this[objType]));
  }

  // reusable h
  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title,
      message,
      variant
    });
    this.dispatchEvent(event);
  }

  handleSubmit(e) {
    if (!this.accObj.name) {
      this.showToast(
        "Account Field Missing",
        'Please fill the required "Account" Name',
        "warning"
      );
      return;
    }

    if ((this.conObj.firstName || this.conObj.email) && !this.conObj.lastName) {
      this.showToast(
        "Contact Field Missing",
        'Please fill the required "Contact" Last Name',
        "warning"
      );
      return;
    }

    if (!this.oppObj.name && !this.oppObj.stage && !this.oppObj.closeDate) {
      console.log("No opportunity data");
    } else if (
      !this.oppObj.name ||
      !this.oppObj.stage ||
      !this.oppObj.closeDate
    ) {
      this.showToast(
        "Field Missing",
        'Please fill all required "Opportunity" fields',
        "warning"
      );
      return;
    }

    createRecords({
      accName: this.accObj.name,
      accPhone: this.accObj.phone,
      accDesc: this.accObj.desc,
      conFirstName: this.conObj.firstName,
      conLastName: this.conObj.lastName,
      conEmail: this.conObj.email,
      oppName: this.oppObj.name,
      oppStage: this.oppObj.stage,
      oppCloseDate: this.oppObj.closeDate
    })
      .then((accId) => {
        this.showToast(
          "Success",
          `Account Created Successfully with Id: ${accId}`,
          "success"
        );

        this.clearForm();
        console.log("Record Creation Successful, Account Id: ", accId);

        this[NavigationMixin.Navigate]({
          type: "standard__recordPage",
          attributes: {
            recordId: accId,
            objectApiName: "Account",
            actionName: "view"
          }
        });
      })
      .catch((err) => {
        this.showToast(
          "Error",
          "Something went wrong while creating records",
          "error"
        );
        console.error("Error: ", err);
      });
  }
}
