import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
		const el = this.element

		/*el.querySelectorA("[data-toggle='tab']").on("click", (e)=>{
			e.preventDefault()
			const tabId = document.querySelector(e.currentTarget).attr("href")
			const tab = document.querySelector(tabId)
			tab.siblings(".tab-pane.active").toggleClass("active")
			if(tab.hasClass('active')) return
			tab.toggleClass("active")
		})*/
  }

	changeTab(e){
		e.preventDefault()
		console.log("change tab", e.target)
		const tab = document.querySelector(e.currentTarget.dataset.tab)

		
		for (const tabLink of document.querySelectorAll(".tab-link")) {
			tabLink.classList.remove("bg-brand-100", "text-brand-700");
			tabLink.classList.add("text-brand-500", "hover:text-brand-700");
		}

		e.target.classList.add("bg-brand-100", "text-brand-700")


		const panes = document.querySelectorAll(".tab-pane")

		for (const pane of panes) {
			pane.classList.add('hidden');
		}

		tab.classList.remove("hidden")
	}
}
