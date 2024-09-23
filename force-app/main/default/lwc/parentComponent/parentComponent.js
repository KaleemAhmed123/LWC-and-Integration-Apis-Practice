import { LightningElement } from "lwc";

export default class ParentComponent extends LightningElement {
  percentage = 10;

  handleChange(event) {
    this.percentage = event.target.value;
  }

  handleReset() {
    this.percentage = 0;
    // this.template.querySelector("c-child-component").reset();
  }

  childReset() {
    this.template.querySelector("c-child-component").childReset();
  }
}
