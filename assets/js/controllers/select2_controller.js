
import { Controller } from '@hotwired/stimulus';

const parseSelect2OptionName = (item) => {
  item = item.slice(7);
  return item.charAt(0).toLowerCase() + item.slice(1);
};

export default class extends Controller {
  get select() {
    return $(this.element);
  }

  get options() {
    let data = this.select.data();
    let options = {};

    for (let item in data) {
      if (item.indexOf('select2') > -1) {
        options = { ...options, [parseSelect2OptionName(item)]: data[item] };
      }
    }

    return options;
  }

  connect() {
    this.select.select2(this.options);
  }

  disconnect() {
    this.select.select2('destroy');
  }
}