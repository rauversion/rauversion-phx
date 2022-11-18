// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

import "./controllers"

import InfiniteScroll from "./hooks/infinite_scroll"
import Player from "./hooks/player"
import TrackHook from "./hooks/track_hook"
import Editor from "./hooks/editor"
import ArticleContent from "./hooks/article_content"
import PlayButton from "./hooks/play_button"
import { datetimeHook } from './hooks/datetime_picker'

import create from 'zustand/vanilla'
import { persist } from 'zustand/middleware'

window.dispatchMapsEvent = function (...args) {
  const event = document.createEvent("Events")
  event.initEvent("google-maps-callback", true, true)
  event.args = args
  window.dispatchEvent(event)
}


const store = create(
  persist(
    (set, get) => ({
      volume: 0.9,
      playlist: [],
      //addAFish: () => set({ fishes: get().fishes + 1 }),
    }),
    {
      name: 'rau-storage', // unique name
      getStorage: () => localStorage // sessionStorage, // (optional) by default, 'localStorage' is used
    }
  )
)

const { getState, setState, subscribe, destroy } = store

subscribe((v)=> {
  console.log("value changes", v)
})

// setState({fishes: 1})
window.store = store

if (!Array.isArray(store.getState().playlist)){
  store.setState({playlist: []})
}

// import * as ActiveStorage from "@rails/activestorage"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

let execJS = (selector, attr) => {
  document.querySelectorAll(selector).forEach(el => liveSocket.execJS(el, el.getAttribute(attr)))
}

let Hooks = {}

Hooks.PlayButton = PlayButton
Hooks.Player = Player
Hooks.TrackHook = TrackHook
Hooks.InfiniteScroll = InfiniteScroll
Hooks.Editor = Editor
Hooks.ArticleContent = ArticleContent
Hooks.DatetimeHook = datetimeHook

Hooks.currentTimezone = {
  mounted(){
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    // console.log(timezone); // Asia/Karachi
    this.el.innerHTML = timezone
  }
}

Hooks.PlayerInitiator = {
  mounted(){
    this.updateFromStorage()  
  },
  updateFromStorage(){
    // append a 0 to list because https://github.com/elixir-lang/elixir/wiki/FAQ#4-why-is-my-list-of-integers-printed-as-a-string
    let ids = [...window.store.getState().playlist, 0 ]
    ids = JSON.stringify(ids)
    console.log("UPDATE FROM STORAGE", ids)

    this.pushEvent("update-from-storage", {ids: ids } )
  },
}


// handler for remove playlist, this is basically because we are using pxh-update=append on the playlist list
window.addEventListener(`phx:remove-item`, (e) => {
  let el = document.getElementById(e.detail.id)
  console.log("REMOVE ITEM", el, e.detail.id)
  if(el) {
    el.remove()
  }
})

window.addEventListener(`phx:add-to-next`, (e) => {
  console.log("ADD TO NEXT ITEM", e.detail)
  store.setState({playlist: [e.detail.value.id, ...store.getState().playlist ]})
})

window.addEventListener(`phx:playlist-clear`, (e) => {
  console.log("REMOVE PLAYLIST CLEAR", e.detail)
  store.setState({playlist: e.detail.ids})
})

window.addEventListener(`phx:remove-from-playlist`, (e) => {
  console.log("REMOVE PLAYLIST CLEAR", e.detail.index)
  const index = parseInt(e.detail.index)
  let ids = store.getState().playlist
  
  if (index > -1) { // only splice array when item is found
    ids.splice(index, 1); // 2nd parameter means remove one item only
    console.log("new list", ids)
    store.setState({playlist: ids})
  }
})

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {
  _csrf_token: csrfToken,
  timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
  timezone_offset: -(new Date().getTimezoneOffset() / 60)
  //store: JSON.stringify(store.getState().playlist)
}})

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
