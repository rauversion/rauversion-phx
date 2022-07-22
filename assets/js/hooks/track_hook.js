
import WaveSurfer from 'wavesurfer.js'

Player = {
  // page() { return this.el.dataset.page },
  mounted(){

    //this.currentSongIndex = 0
    //this.currentSong = window.store.getState().playlist[this.currentSongIndex]

    this.playerTarget = this.el //.querySelector('[data-audio-target="player"]')
    this.peaks = this.el.dataset.audioPeaks
    this.url = this.el.dataset.audioUrl
    this.height = this.el.dataset.audioHeightValue
    
    this.playiconTarget = this.el.querySelector('[data-audio-target="playicon"]')
    this.pauseiconTarget = this.el.querySelector('[data-audio-target="pauseicon"]')
    this.playBtn = this.el.querySelector('[data-audio-target="play"]')

    this.playing = false 

    this.drawerListener = null

    this.playBtnListener = this.playBtn.addEventListener("click", (e)=>{
      if(!this.playing){
        this.pushEventTo("#main-player", "play-song", {id: this.el.dataset.audioId } )
      } else {
        this.dispatchPause()
      }
    })

    this.addFromPlaylistListener = window.addEventListener(`phx:add-from-playlist`, (e) => {
      console.log("ADD FROM PLAYLIST", e.detail)
      this.pushEventTo("#main-player", "play-song", {id: e.detail.track_id } )
    })

    this.audioProcessListeners = 
      document.addEventListener(`audio-process-${this.el.dataset.audioId}`, (e) => {
      // console.log("AUDIO PROCESS RECEIVED", e.detail)
      // this._wave.drawer.progressWave.style.width = `${e.detail}px`
      // this._wave.drawer.progress(e.detail)
      // this.drawer.progress(this.backend.getPlayedPercents());
      this._wave.drawer.progress(e.detail.percent)
      })

    this.audioProcessPlayListeners = 
      document.addEventListener(`audio-process-${this.el.dataset.audioId}-play`, (e) => {
        this.playiconTarget.style.display = 'block'
        this.pauseiconTarget.style.display = 'none'
        this.playing = true
        this._wave.drawer.progress(e.detail.percent)
      })

    this.audioProcessPauseListeners = 
      document.addEventListener(`audio-process-${this.el.dataset.audioId}-pause`, (e) => {
        this.playiconTarget.style.display = 'none'
        this.pauseiconTarget.style.display = 'block'
        this.playing = false
        this._wave.drawer.progress(e.detail.percent)
      })

    /*window.addEventListener(`phx:play-song`, (e) => {
      console.log("PLAY SONG", e.detail)
      // this.el.dataset.playerPeaks = e.detail.peaks
      // this.el.dataset.playerUrl = e.detail.url
      setTimeout(()=>{
        this.destroyWave();
        this.initWave();
        // this.playSong()
      }, 400)
    })*/

    this._wave = null
    this.initWave()

  },
  destroyed(){
    this.playBtn.removeEventListener("click", this.playBtnListener)
    this._wave && this._wave.drawer.wrapper.removeEventListener('click', this.drawerListener )
    window.removeEventListener(`phx:add-from-playlist`, this.addFromPlaylistListener)
    document.removeEventListener(`audio-process-${this.el.dataset.audioId}`, this.audioProcessListeners)
    document.removeEventListener(`audio-process-${this.el.dataset.audioId}-play`, this.audioProcessPlayListeners)
    document.removeEventListener(`audio-process-${this.el.dataset.audioId}-pause`, this.audioProcessPauseListeners)
    this.destroyWave()
  },
  initWave(){
    this.peaks = this.el.dataset.audioPeaks
    this.url = this.el.dataset.audioUrl

    if(!this.url) return

    this._wave = WaveSurfer.create({
      container: this.playerTarget,
      backend: 'MediaElement',
      waveColor: 'grey',
      progressColor: 'tomato',
      height: this.height || 45,
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
      fillParent: true
    })

    const data = JSON.parse(this.peaks) 
    this._wave.load(this.url, data)
    
    this._wave.on('ready', ()=> {
      console.log("READY")
      // sends the progress position to track_component
      this.drawerListener = this._wave.drawer.wrapper.addEventListener('click', (e)=> {

        setTimeout(()=>{
          const trackId = this.el.dataset.audioId
          const ev = new CustomEvent(`audio-process-mouseup`, {
            detail: {
             trackId: trackId,
             postition: this._wave.drawer.lastPos,
             percent: this._wave.backend.getPlayedPercents()
           }
          });
          document.dispatchEvent(ev)
        }, 20)

      });
    })
  },
  destroyWave() {
    this._wave && this._wave.destroy()
  },
  playSong(){
    this._wave && this._wave.playPause()
  },
  dispatchPause(){
    const trackId = this.el.dataset.audioId
    const ev = new CustomEvent(`audio-pause`, {
      detail: {
       trackId: trackId
     }
    });
    document.dispatchEvent(ev)
  },
  reconnected(){ },
  updated(){ }

}

export default Player