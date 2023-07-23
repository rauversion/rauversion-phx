// scroll_controller.js
import { Controller } from "@hotwired/stimulus"

/*


  <div data-controller="scroll">

    <div class="flex justify-between">
    
      <p class="mt-1 text-sm text-gray-500">
        Featured Categories
      </p>

      <div class="flex items-center space-x-2">
        <button data-action="click->scroll#scrollBackward" class="text-sm font-medium text-indigo-600 hover:text-indigo-500 md:block">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
            <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15m0 0l6.75 6.75M4.5 12l6.75-6.75" />
          </svg>
        </button>

        <button data-action="click->scroll#scrollForward" class="text-sm font-medium text-indigo-600 hover:text-indigo-500 md:block">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
            <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12h15m0 0l-6.75-6.75M19.5 12l-6.75 6.75" />
          </svg>
        </button>
      </div>
    </div>

    <div class="relative">
      <div class="overflow-auto no-scrollbar relative" data-scroll-target="scrollContainer">
        <div class="mt-6 grid grid-cols-1- grid-flow-col grid-rows-1- sm:gap-x-2 md:grid-cols-4- md:gap-y-0- lg:gap-x-8">
          <% @categories.each do |category| %>
            <%= render "category_item", category: category %>
          <% end %>
        </div>
      </div>
    </div>
  </div>

*/


export default class extends Controller {
  static targets = ["scrollContainer"]

  scrollForward() {
    this.scrollContainerTarget.scrollBy({
      left: 200, // change to the amount you want to scroll
      behavior: 'smooth'
    });
  }

  scrollBackward() {
    this.scrollContainerTarget.scrollBy({
      left: -200, // change to the amount you want to scroll
      behavior: 'smooth'
    });
  }
}