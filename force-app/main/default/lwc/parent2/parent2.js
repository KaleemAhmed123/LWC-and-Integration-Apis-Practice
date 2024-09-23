import { LightningElement } from "lwc";
export default class Parent2 extends LightningElement {
  showModal = false;
  clickHandler() {
    this.showModal = true;
  }
  closeHandler() {
    this.showModal = false;
  }
}
