// taken from: https://elixircasts.io/infinite-scroll-with-liveview

let scrollAt = () => {
  let scrollTop = document.documentElement.scrollTop || document.body.scrollTop
  let scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight
  let clientHeight = document.documentElement.clientHeight

  return scrollTop / (scrollHeight - clientHeight) * 100
}

InfiniteScroll = {
  page() { return this.el.dataset.page },
  mounted(){
    this.pending = this.page()
    
    const target = this.el?.attributes["phx-target"]?.nodeValue
    window.addEventListener("scroll", e => {
      if(this.pending == this.page() && scrollAt() > 90){
        console.log(this.el.dataset.paginateEnd)
        console.log(this.el.dataset.page, this.el.dataset.totalPages)
        this.pending = this.page()
        this.pushEventTo(target, "paginate", {})
      }
    })
  },
  reconnected(){ this.pending = this.page() },
  updated(){ this.pending = this.page() }
}

export default InfiniteScroll