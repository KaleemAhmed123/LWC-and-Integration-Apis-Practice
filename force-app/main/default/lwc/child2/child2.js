import { LightningElement } from "lwc";

export default class Child2 extends LightningElement {
  closeHandler() {
    const myEvent = new CustomEvent("close");
    this.dispatchEvent(myEvent);
  }
}
