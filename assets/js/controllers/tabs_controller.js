import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
		const el = $(this.element)

		el.find("[data-toggle='tab']").on("click", (e)=>{
			e.preventDefault()
			const tabId = $(e.currentTarget).attr("href")
			const tab = $(tabId)
			tab.siblings(".tab-pane.active").toggleClass("active")
			if(tab.hasClass('active')) return
			tab.toggleClass("active")
		})
  }
}
