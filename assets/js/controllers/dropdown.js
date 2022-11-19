import { Controller } from '@hotwired/stimulus'
import { useTransition } from 'stimulus-use'

export default class extends Controller {
  /*menuTarget: HTMLElement
  toggleTransition: (event?: Event) => void
  leave: (event) => void
  transitioned: false*/

  static classes = [ "hidden" ] 

  static targets = ['menu']

  connect () {
    useTransition(this, {
      element: this.menuTarget,
      hiddenClass: false
    })
  }

  toggle () {
    this.menuTarget.classList.toggle("hidden")
    this.toggleTransition()
  }

  hide (event) {
    // @ts-ignore
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains('hidden')) {
      //console.log("LEAVING", this.element.id)
      this.leave()
    }
  }
}