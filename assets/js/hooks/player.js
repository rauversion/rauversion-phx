
import WaveSurfer from 'wavesurfer.js'

Player = {
  mounted(){

    this.waveClickListener = null

    this.currentSongIndex = 0
    this.currentSong = window.store.getState().playlist[this.currentSongIndex]

    this.playerTarget = this.el.querySelector('[data-player-target="player"]')
    this.peaks = this.el.dataset.playerPeaks
    this.url = this.el.dataset.playerUrl
    
    this.playiconTarget = this.el.querySelector('[data-player-target="playicon"]')
    this.pauseiconTarget = this.el.querySelector('[data-player-target="pauseicon"]')
    this.loadingiconTarget = this.el.querySelector('[data-player-target="loadingicon"]')

    this.range = this.el.querySelector('#player-range')

    this.range.value = window.store.getState().volume

    this.playBtn = this.el.querySelector('[data-player-target="play"]')

    this.playBtnListener = (e)=>{
      //this.pauseiconTarget.style.display = 'block'
      //this.loadingiconTarget.style.display = 'block'
      //this.playiconTarget.style.display = 'none'
      this._wave.playPause()
    }
    
    this.nextBtn = this.el.querySelector('[data-player-target="next"]')
    this.rewBtn = this.el.querySelector('[data-player-target="rew"]')

    this.nextBtnClickListener = (e)=>{
      this.nextSong()
    }
    
    this.prevBtnClickListener = (e)=>{
      this.prevSong()
    }

    this.rangeChangeListener = (e)=>{
      window.store.setState({volume: e.target.value})
      this._wave.setVolume(e.target.value)
    }
    
    this.addToNextListener = (e) => {
      console.log("ADD TO NEXT ITEM", e.detail)
      this.pushEvent("add-song", {id: e.detail.value.id } )
    }
    
    this.playSongListener = (e) => {
      console.log("PLAY SONG", e.detail)

      this.pauseiconTarget.style.display = 'none'
      this.loadingiconTarget.style.display = 'block'
      this.playiconTarget.style.display = 'none'

      // this.el.dataset.playerPeaks = e.detail.peaks
      // this.el.dataset.playerUrl = e.detail.url


      this._wave.stop()
      this._wave.once('ready', () => this._wave.play())
      setTimeout(()=>{
        this._wave.load(this.el.dataset.playerUrl, JSON.parse(this.el.dataset.playerPeaks))
      }, 400)
    }

    this.waveClickListener = (e)=> {

      setTimeout(()=>{
        const trackId = this.el.dataset.trackId
        const ev = new CustomEvent(`audio-process-${trackId}`, {
          detail: {
           position: this._wave.getCurrentTime(),
           percent: this._wave.getCurrentTime() / this._wave.getDuration()
         }
        });
        document.dispatchEvent(ev)

      }, 20)

    }

    this.mouseUpHandler = (e) => {
      if(e.detail.trackId == this.el.dataset.trackId){
        this._wave.seekTo(e.detail.percent)
        //this._wave.drawer.progress(e.detail.percent)
      }
    }

    this.audioPauseHandler = (e) => {
      if(e.detail.trackId == this.el.dataset.trackId){
        this._wave.pause()
      }
    }

    this.playBtn.addEventListener("click", this.playBtnListener)
    this.nextBtn.addEventListener("click", this.nextBtnClickListener)
    this.rewBtn.addEventListener("click", this.prevBtnClickListener)
    this.range.addEventListener("change", this.rangeChangeListener)
    window.addEventListener(`phx:add-to-next`, this.addToNextListener)
    window.addEventListener(`phx:play-song`, this.playSongListener)

    this._wave = null
    this.initWave()
  },
  destroyed(){
    this.playBtn && this.playBtn.removeEventListener("click", this.playBtnListener)
    this.nextBtn && this.nextBtn.removeEventListener("click", this.nextBtnClickListener)
    this.rewBtn && this.rewBtn.removeEventListener("click", this.prevBtnClickListener)
    this.range && this.range.removeEventListener("change", this.rangeChangeListener )
    this?._wave?.drawer?.wrapper?.removeEventListener("click", this.waveClickListener)
    
    document.removeEventListener('audio-process-mouseup', this.mouseUpHandler)
    document.removeEventListener('audio-pause', this.audioPauseHandler)

    window.removeEventListener(`phx:add-to-next`, this.addToNextListener)
    window.removeEventListener(`phx:play-song`, this.playSongListener)

    this.destroyWave()
  },
  initWave(){
    this.peaks = this.el.dataset.playerPeaks
    this.url = this.el.dataset.playerUrl

    this._wave = WaveSurfer.create({
      container: this.playerTarget,
      autoplay: true,
      waveColor: 'grey',
      progressColor: 'tomato',
      height: 45,
      barWidth: 2,
      barGap: 3,
      responsive: true,
      //minPxPerSec: 2,
      pixelRatio: 10,
      //cursorWidth: 1,
      //cursorColor: "lightgray",
      volume: this.range.value
    })

    window.w = this._wave

    this._wave.setVolume( window.store.getState().volume )

    const data = JSON.parse(this.peaks) 
    this._wave.load(this.url, data)

    this._wave.on('pause', ()=> {
      this.dispatchPause()
    })

    this._wave.on('play', ()=> {
      console.log("play")
      this.dispatchPlay()
    })

    /*this._wave.backend.on('canplay', () => {
      console.log("CAN PLAY!!")
      this.loadingiconTarget.style.display = 'none'
    });*/

    this._wave.on('audioprocess', (e)=> {
      const trackId = this.el.dataset.trackId
      // console.log("AUDIO PROCESS", e)
      const ev = new CustomEvent(`audio-process-${trackId}`, {
        detail: {
          position: this._wave.getCurrentTime(), //this._wave.drawer.lastPos,
          percent: this._wave.getCurrentTime() / this._wave.getDuration()
        }
      });
      document.dispatchEvent(ev)
    })

    this._wave.on('ready', ()=> {
      console.log("PLAYER READY")
      // sends the progress position to track_component
      //this.playiconTarget.style.display = 'block'
      //this.loadingiconTarget.style.display = 'none'

      this._wave.getWrapper().addEventListener('click', this.waveClickListener)
      //this._wave.drawer.wrapper.addEventListener('click', this.waveClickListener)
    })

    // receives audio-process progress from track hook
    document.addEventListener('audio-process-mouseup', this.mouseUpHandler)

    // receives pause
    document.addEventListener('audio-pause', this.audioPauseHandler)

    this._wave.on('finish', (e) => {
      console.log("FINISH PROCESS")
      this.nextSong()
    })
  },
  dispatchPlay(){
    this.playiconTarget.style.display = 'block'
    this.loadingiconTarget.style.display = 'none'
    // this.loadingiconTarget.style.display = 'block'
    this.pauseiconTarget.style.display = 'none'

    const trackId = this.el.dataset.trackId
    const ev = new CustomEvent(`audio-process-${trackId}-play`, {
      detail: {}
    });
    document.dispatchEvent(ev)
    //setTimeout(()=>{
      // if(this.)
      this.trackEvent(trackId)
    //}, 2000)
    
  },
  dispatchPause(){
    this.playiconTarget.style.display = 'none'
    this.pauseiconTarget.style.display = 'block'
    this.loadingiconTarget.style.display = 'none'
    const trackId = this.el.dataset.trackId
    const ev = new CustomEvent(`audio-process-${trackId}-pause`, {
      detail: {}
    });
    document.dispatchEvent(ev)
  },
  destroyWave() {
    this?._wave?.destroy()
  },
  nextSong(){
    //this.destroyWave()
    this.pushEvent("request-song", {action: "next"} )
    console.log("no more songs to play")
  },
  prevSong(){
    //this.destroyWave()
    this.pushEvent("request-song", {action: "prev"} )
  },
  playSong(){
    this._wave.playPause()
  },
  trackEvent(trackId) {
    fetch(`/api/tracks/${trackId}/events`)
      .then(response => response.json())
      .then(data => console.log(data));
  },
  reconnected(){ },
  updated(){ }
}

export default Player