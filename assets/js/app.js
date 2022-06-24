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

import { Application } from "@hotwired/stimulus"

import "./controllers"

import WaveSurfer from 'wavesurfer'

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


Hooks.AudioPlayer = {
  mounted(){
    this.heightValue = 70
    this.playerTarget = this.el
    this.peaks = JSON.parse(this.el.dataset.audioPeaks)
    this.url = this.el.dataset.audioUrl
    this.playiconTarget = this.el.querySelector('[data-audio-target="playicon"]')
    this.pauseiconTarget =  this.el.querySelector('[data-audio-target="pauseicon"]')

    this._wave = WaveSurfer.create({
      container: this.playerTarget,
      backend: 'MediaElement',
      waveColor: 'grey',
      progressColor: 'tomato',
      height: this.heightValue || 70,
      //fillParent: false,
      barWidth: 2,
      //barHeight: 10, // the height of the wave
      barGap: null,
      minPxPerSec: 2,
      pixelRatio: 10,
      cursorWidth: 1,
      cursorColor: "lightgray",
      normalize: false,
      responsive: true,
      fillParent: true
    })

    console.log("VAUES",this.peaks)

    if (!this.url) return 
    
    this._wave.load(this.url, this.peaks)

    this._wave.on('pause', ()=> {
      this.playiconTarget.style.display = 'block'
      this.pauseiconTarget.style.display = 'none'
    })

    this._wave.on('play', ()=> {
      this.playiconTarget.style.display = 'none'
      this.pauseiconTarget.style.display = 'block'
    })
  },

  wave(){
    return this._wave
  },

  play(opts = {}){
    this.wave().playPause()
  },

  pause(){
    clearInterval(this.progressTimer)
    this.player.pause()
  },

  stop(){
    this.wave().stop()
  },
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
