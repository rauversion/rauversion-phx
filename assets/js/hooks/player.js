
import WaveSurfer from 'wavesurfer.js'

Player = {
  mounted(){

    this.currentSongIndex = 0
    this.currentSong = window.store.getState().playlist[this.currentSongIndex]

    this.playerTarget = this.el.querySelector('[data-player-target="player"]')
    this.peaks = this.el.dataset.playerPeaks
    this.url = this.el.dataset.playerUrl
    
    this.playiconTarget = this.el.querySelector('[data-player-target="playicon"]')
    this.pauseiconTarget = this.el.querySelector('[data-player-target="pauseicon"]')
    this.range = this.el.querySelector('#player-range')

    this.range.value = window.store.getState().volume

    this.playBtn = this.el.querySelector('[data-player-target="play"]')

    this.playBtn.addEventListener("click", (e)=>{
      this._wave.playPause()
    })

    this.nextBtn = this.el.querySelector('[data-player-target="next"]')
    this.rewBtn = this.el.querySelector('[data-player-target="rew"]')

    this.nextBtn.addEventListener("click", (e)=>{
      this.nextSong()
    })

    this.rewBtn.addEventListener("click", (e)=>{
      this.prevSong()
    })

    this.range.addEventListener("change", (e)=>{
      window.store.setState({volume: e.target.value})
      this._wave.setVolume(e.target.value)
    })

    window.addEventListener(`phx:add-to-next`, (e) => {
      console.log("ADD TO NEXT ITEM", e.detail)
      this.pushEvent("add-song", {id: e.detail.value.id } )
    })

    window.addEventListener(`phx:play-song`, (e) => {
      console.log("PLAY SONG", e.detail)
      // this.el.dataset.playerPeaks = e.detail.peaks
      // this.el.dataset.playerUrl = e.detail.url
      setTimeout(()=>{
        this.destroyWave();
        this.initWave();
        this.playSong()
      }, 400)
    })
    this._wave = null
    this.initWave()
  },
  initWave(){
    this.peaks = this.el.dataset.playerPeaks
    this.url = this.el.dataset.playerUrl

    this._wave = WaveSurfer.create({
      container: this.playerTarget,
      backend: 'MediaElement',
      waveColor: 'grey',
      progressColor: 'tomato',
      height: 45,
      //fillParent: false,
      barWidth: 1,
      //barHeight: 10, // the height of the wave
      barGap: null,
      minPxPerSec: 2,
      pixelRatio: 10,
      cursorWidth: 1,
      cursorColor: "lightgray",
      normalize: false,
      responsive: true,
      fillParent: true,
      volume: this.range.value
    })

    this._wave.setVolume( window.store.getState().volume )

    const data = JSON.parse(this.peaks) 
    this._wave.load(this.url, data)

    this._wave.on('pause', ()=> {
      this.dispatchPause()
    })

    this._wave.on('play', ()=> {
      this.dispatchPlay()
    })

    this._wave.on('audioprocess', (e)=> {
      const trackId = this.el.dataset.trackId
      // console.log("AUDIO PROCESS", e)
      const ev = new CustomEvent(`audio-process-${trackId}`, {
        detail: {
          postition: this._wave.drawer.lastPos,
          percent: this._wave.backend.getPlayedPercents()
        }
      });
      document.dispatchEvent(ev)
    })

    this._wave.on('ready', ()=> {
      console.log("READY")
      // sends the progress position to track_component
      this._wave.drawer.wrapper.addEventListener('click', (e)=> {

        setTimeout(()=>{

          const trackId = this.el.dataset.trackId
          const ev = new CustomEvent(`audio-process-${trackId}`, {
            detail: {
             postition: this._wave.drawer.lastPos,
             percent: this._wave.backend.getPlayedPercents()
           }
          });
          document.dispatchEvent(ev)

        }, 20)

      });
    })

    // receives audio-process progress from track hook
    document.addEventListener('audio-process-mouseup', (e) => {
      this._wave.drawer.progress(e.detail.percent)
    })

    // receives pause
    document.addEventListener('audio-pause', (e) => {
      this._wave.pause()
    })

    this._wave.on('finish', (e) => {
      console.log("FINISH PROCESS")
      this.nextSong()
    })
  },
  dispatchPlay(){
    this.playiconTarget.style.display = 'block'
    this.pauseiconTarget.style.display = 'none'

    const trackId = this.el.dataset.trackId
    const ev = new CustomEvent(`audio-process-${trackId}-play`, {
      detail: {}
    });
    document.dispatchEvent(ev)
  },
  dispatchPause(){
    this.playiconTarget.style.display = 'none'
    this.pauseiconTarget.style.display = 'block'
    const trackId = this.el.dataset.trackId
    const ev = new CustomEvent(`audio-process-${trackId}-pause`, {
      detail: {}
    });
    document.dispatchEvent(ev)
  },
  destroyWave() {
    if(this._wave) {
      this._wave.destroy()
    }
  },
  nextSong(){
    this.destroyWave()
    this.pushEvent("request-song", {action: "next"} )
    console.log("no more songs to play")
  },
  prevSong(){
    this.destroyWave()
    this.pushEvent("request-song", {action: "prev"} )
  },
  playSong(){
    this._wave.playPause()
  },
  reconnected(){ },
  updated(){ }
}

export default Player