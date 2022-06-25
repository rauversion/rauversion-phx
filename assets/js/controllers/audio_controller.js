import { Controller } from "@hotwired/stimulus"
import WaveSurfer from 'wavesurfer'
export default class extends Controller {
  static targets = ['player', 'play', 'pause', 'playicon', 'pauseicon']

  static values = {
    height: String
  }

  _wave = null

  initialize() {}

  connect() {
    if(!this.data.get('url')) {
      console.error("skip player, no url found!")
      return
    }
    console.log("INIT WAVEEE")
    this.initWave()
  }
  disconnect() {
    this._wave && this._wave.destroy()
  }

  initWave() {
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

    console.log("VAUES",this.data.get('peaks').length)
    const data = JSON.parse(this.data.get('peaks')) 
    this._wave.load(this.data.get('url'), data)

    var _this = this

    _this.pauseTarget.style.display = 'none'
    this._wave.on('pause', function () {
      _this.playiconTarget.style.display = 'none'
      _this.pauseiconTarget.style.display = 'block'
    })
    this._wave.on('play', function () {
      _this.playiconTarget.style.display = 'block'
      _this.pauseiconTarget.style.display = 'none'
    })
  }

  wave(){
    return this._wave
  }

  play(){
    this.wave().playPause()
  }

  pause(){
    this.wave().stop()
  }
}