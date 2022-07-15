
import WaveSurfer from 'wavesurfer'

Player = {
  // page() { return this.el.dataset.page },
  mounted(){

    this.currentSongIndex = 0
    this.currentSong = window.s.getState().playlist[this.currentSongIndex]

    this.playerTarget = this.el.querySelector('[data-player-target="player"]')
    this.peaks = this.el.dataset.playerPeaks
    this.url = this.el.dataset.playerUrl
    
    this.playiconTarget = this.el.querySelector('[data-player-target="playicon"]')
    this.pauseiconTarget = this.el.querySelector('[data-player-target="pauseicon"]')

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
      fillParent: true
    })

    //console.log("VAUES", this.peaks.length)
    const data = JSON.parse(this.peaks) 
    this._wave.load(this.url, data)
    var _this = this

    // _this.pauseTarget.style.display = 'none'
    this._wave.on('pause', ()=> {
      _this.playiconTarget.style.display = 'none'
      _this.pauseiconTarget.style.display = 'block'
    })

    this._wave.on('play', ()=> {
      _this.playiconTarget.style.display = 'block'
      _this.pauseiconTarget.style.display = 'none'
    })

    this._wave.on('audioprocess', (e)=> {
      // console.log("AUDIO PROCESS", e)
    })

    this._wave.on('finish', (e) => {
      console.log("FINISH PROCESS")
      this.nextSong()
    })

    
  },
  destroyWave() {
    this._wave && this._wave.destroy()
  },
  nextSong(){
    const nextSong = window.s.getState().playlist[this.currentSongIndex + 1]
    if(nextSong){
      this.currentSongIndex = this.currentSongIndex+1
      this.currentSong = nextSong
      this.pushEvent("request-song", this.currentSong )
    } else {
      console.log("no more songs to play")
    }
  },
  prevSong(){
    const prevSong = window.s.getState().playlist[this.currentSongIndex - 1]
    if(prevSong){
      this.currentSongIndex = this.currentSongIndex+1
      this.currentSong = prevSong
      this.pushEvent("request-song", this.currentSong )
    } else {
      console.log("no more songs to play")
    }
  },
  playSong(){
    this._wave.playPause()
  },
  reconnected(){ },
  updated(){ }

}

export default Player