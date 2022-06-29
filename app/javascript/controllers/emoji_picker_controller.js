import { Controller } from "@hotwired/stimulus"
import { createPopper } from "@popperjs/core";

export default class extends Controller {
  static targets = ["button", "emojiRoot", "formSubmit", "formInput"]
  static values = { show: Boolean }

  connect() {
    this.popperInstance = createPopper(this.buttonTarget, this.emojiRootTarget)
    this.element.querySelector("emoji-picker").addEventListener("emoji-click", event => { this.selectEmoji(event) })
  }

  toggle() {
    this.showValue = !this.showValue

    // We need to tell Popper to update the tooltip position
    // after we show the tooltip, otherwise it will be incorrect
    this.popperInstance.update()
  }

  selectEmoji(event)  {
    console.log(event)
    this.toggle()
    this.formInputTarget.value = event.detail.emoji.unicode
    this.formSubmitTarget.click()
  }

  disconnect() {
    if (this.showValue) {
      this.toggle()
    }
    this.popperInstance.destroy()
  }
}
