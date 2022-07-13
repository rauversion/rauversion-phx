import EasyMDE from 'EasyMDE'

import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.editor = new EasyMDE({ element: this.element });
  }

  close() {
    this.editor.remove();
  }
}

