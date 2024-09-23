import { LightningElement } from "lwc";
import call from "@salesforce/apex/queryAccount.call";

// typ URL se base URL add ho jata hai
const columns = [
  {
    fieldName: "recUrl",
    type: "url",
    typeAttributes: {
      label: { fieldName: "Name" },
      target: "_blank"
    },
    sortable: true,
    cellAttributes: {
      iconName: "utility:trending",
      iconAlternativeText: "Account Name"
    }
  },
  { label: "Website", fieldName: "website", type: "url" },
  { label: "Phone", fieldName: "phone", type: "phone" },
  { label: "Rating", fieldName: "Rating", type: "text" }
];

export default class SearchAccountTable extends LightningElement {
  query = null;
  records = [];
  columns = columns;
  showTable = false;

  handleChange(e) {
    this[e.target.name] = e.target.value;
    if (e.target.value === "") {
      this.showTable = false;
    }
  }

  handleSubmit(e) {
    call({ query: this.query })
      .then((res) => {
        // copyng data and add dynamic URL
        this.records = res.map((data) => ({
          ...data,
          recUrl: `/lightning/r/Account/${data.Id}/view`
        }));
        this.showTable = true;
      })
      .catch((err) => {
        console.error("Error:", err);
      });
  }

  handleSubmitEnter(e) {
    if (e.keyCode === 13) {
      this.handleSubmit();
    }
  }

  redirect(e) {
    console.log("redirec handler........");
  }
}
