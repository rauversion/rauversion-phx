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
    this.wave()
  }
  disconnect() {}

  wave(){
    if (this._wave == undefined) {
      this._wave = WaveSurfer.create({
        container: this.playerTarget,
        backend: 'MediaElement',
        waveColor: 'violet',
        progressColor: 'purple',
        height: this.heightValue || 70,
        //partialRender: true,
        pixelRatio: 1,
        //fillParent: false,
        barWidth: 2,
        barHeight: 10, // the height of the wave
        barGap: null 
      })
      this._wave.load(this.data.get('url'))
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