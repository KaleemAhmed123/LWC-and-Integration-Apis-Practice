class Temp {
  constructor() {
    this.firstName = "Kaleem";
    this.lastName = "Ahmed";
  }

  getFullName() {
    return (this.firstName + " " + this.lastName).toUpperCase();
  }
}

let var1 = "Kaleen";
let var2 = "Kaleen";

let ans = var1 + "   " + var2;
console.log("OUTPUT 1: ", ans);

let ans2 = `${2 + 3} ${var1}  ${var2}`;
console.log(ans2);
