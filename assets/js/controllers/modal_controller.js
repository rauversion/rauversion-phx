import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {}

  close() {
    this.element.remove();
  }
}
