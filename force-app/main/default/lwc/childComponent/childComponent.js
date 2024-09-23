import { LightningElement, api } from "lwc";

export default class ChildComponent extends LightningElement {
  @api percentage;

  // gives warning because it is supposed to be controlled by parent
  // not supposed to be mutated by child directly but does not give error and works fine
  // if changes are made in child component with child method they are limited to child only
  // it doesn't reflect to parent
  @api childReset() {
    this.percentage = 50;
  }
}
