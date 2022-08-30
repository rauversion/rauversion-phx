PlayButton = {
  mounted(){
    this.playBtn = this.el.querySelector('[data-play-button="button"]')
    this.playBtnListener = (e)=>{
      this.play()
    }
    this.playBtn.addEventListener("click", this.playBtnListener)
  },
  play(){
    // console.log("ADD FROM PLAYER")
    this.pushEventTo("#main-player", "play-song", {id: this.el.dataset.audioId } )
  },
  destroyed(){
    this.playBtn && this.playBtn.addEventListener("click", this.playBtnListener)
  }
}

export default PlayButton