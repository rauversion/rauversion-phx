
VideoStream = {
  mounted(){
    console.log("VIDEO SRC")
    var video = this.el;
    var videoSrc = window.location.origin + `/video/index.m3u8`;
    if (Hls.isSupported()) {
      var hls = new Hls();
      hls.loadSource(videoSrc);
      hls.attachMedia(video);
    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = videoSrc;
    }
  },
  reconnected(){ },
  updated(){ }
}

export default VideoStream