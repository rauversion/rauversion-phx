// app/javascript/controllers/infinite_scoll_controller.js

import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ["scrollArea", "pagination"]

  connect() {
    this.createObserver()
  }
  createObserver() {
    const observer = new IntersectionObserver(
      entries => this.handleIntersect(entries),
      {
        // https://github.com/w3c/IntersectionObserver/issues/124#issuecomment-476026505
        threshold: [0, 1.0],
      }
    )
    observer.observe(this.scrollAreaTarget)
  }
  handleIntersect(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        this.loadMore()
      }
    })
  }
  loadMore() {
    const next = this.paginationTarget.querySelector("[rel=next]")
    if (!next) {
      return
    }
    const href = next.href
    fetch(href, {
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      },
    })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
      .then(_ => history.replaceState(history.state, "", href))
  }
}


/*

// stefanwienert.de/blog/2021/04/17/endless-scroll-with-turbo-streams/

// index.html.slim

.list-group(data-controller="infinite-scroll")
  // If you need to enable Live Updates, you could connect to a
  // = turbo_stream_from current_user, :posts
  #posts
    = render @posts
  div(data-infinite-scroll-target='scrollArea')

  #pagination.list-group-item.pt-3(data-infinite-scroll-target="pagination")
    == pagy_bootstrap_nav(@pagy)
In this index we,

wrap our posts with a Stimulus Controller and
mark the posts into a div with id=posts (to later append to)
add a scrollArea empty element div just below our posts list - This area will be used for our Intersection Observer later on
add the pagy_nav or pagy_bootstrap_nav pagination tags on the bottom, also wrapped in a Stimulus Target to later on pick the next page’s link from it
Now, before we modify the controller to respond to Turbo events, we implement the Stimulus Controller



*/