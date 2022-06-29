import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    endAt: String
  }
  connect() {
    this.endTime = Date.parse(this.endAtValue)
    this.updateTimeLeft()
    this.timer = setInterval(this.updateTimeLeft.bind(this), 500)
  }

  updateTimeLeft() {
    const now = new Date().getTime();

    // Find the distance between now and the count down date
    const distance = this.endTime - now;
    // Time calculations minutes and seconds
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((distance % (1000 * 60)) / 1000);

    // Display the result in the element with id="demo"
    let result = ("00" + minutes).slice(-2) + ":" + ("00" + seconds).slice(-2);

    // If the count down is finished, write some text
    if (distance < 0) {
      clearInterval(this.timer);
      result = "Finished!";
    }

    this.element.innerHTML = result
  }
}
