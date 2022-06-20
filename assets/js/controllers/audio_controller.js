// app/javascript/controllers/audio_controller.js
import { Controller } from "@hotwired/stimulus"
import WaveSurfer from 'wavesurfer'

export default class extends Controller {
  static targets = ['player', 'play', 'pause']

  static values = {
    height: String
  }

  initialize() {}
  connect() {
    console.log("INIT WAVEEE")
    this.wave()
  }
  disconnect() {}

  wave(){
    if (this._wave == undefined) {
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
        normalize: true,
        responsive: true,
        fillParent: true
      })


      console.log("VAUES",this.data.get('peaks').length)
      const data = JSON.parse(this.data.get('peaks')) // [0.45,0.54,0.43,0.61,0.47,0.71,0.42,0.59,0.39,0.59,0.41,0.57,0.39,0.59,0.41,0.56,0.43,0.57,0.44,0.59,0.45,0.6,0.44,0.56,0.42,0.63,0.4,0.63,0.36]
      this._wave.load(this.data.get('url'), data)

      window.tt = this


      var _this = this
      // var that = this
      _this.pauseTarget.style.display = 'none'
      this._wave.on('pause', function () {
        _this.playTarget.style.display = 'block'
        _this.pauseTarget.style.display = 'none'
      })
      this._wave.on('play', function () {
        _this.playTarget.style.display = 'none'
        _this.pauseTarget.style.display = 'block'
      })
    }
    return this._wave
  }

  play(){
    this.wave().play()
  }

  pause(){
    this.wave().pause()
  }
}