import { LightningElement, track } from 'lwc';

export default class CountDownTimer extends LightningElement {
    @track counter = 0;
    @track timerCounter = 0;
    timerId = null;

    increment() {
        this.counter++;
    }
    decrement() {
        this.counter--;
    }

    start() {
        if(this.timerId === null) {
            this.timerId = setInterval(() => {
                this.timerCounter++;
            }, 1000);
        }
    }

    stop() {
        if(this.timerId !== null) {
            clearInterval(this.timerId);
            this.timerId = null;
        }
    }

    reset() {
        this.stop();
        this.timerCounter = 0;
    }
}