# Rauversion

---

![image](https://user-images.githubusercontent.com/11976/174422926-b392a1f5-bd6a-4bd2-b6c8-8d41dad6711d.png)

Rauversion is an open source music sharing platform.

Rauversion is built on Elixir with Phoenix framework.

## setup
  
You can develop directly in a container with [vscode devcontainer](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) or [neovim devcontainer](https://github.com/jamestthompson3/nvim-remote-containers)
  
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * rename `.env.example` to `.env` and add your variable configurations
  * Create and migrate your database with `mix ecto.setup`
  * Create some fake accounts `mix fake_accounts`
  * Compile assets `cd assets && yarn install & cd ..`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## images

### TODO

- [x] User account
- [x] File uploads Avatar
- [x] User auth
- [x] Tracks
- [ ] Reposts
- [ ] Albums
- [ ] Playlists
- [ ] Likes
- [ ] Followers / Followings
- [ ] load waveform data as data
- [x] Range responses https://github.com/elixir-plug/plug/pull/526/files

with audiowaveform
  audiowaveform -i ~/Desktop/patio/STE-098.mp3 -o long_clip.json --pixels-per-second 20 --bits 8

as binary
 ffmpeg -i ~/Desktop/patio/STE-098.mp3 -ac 1 -filter:a aresample=200 -map 0:a -c:a pcm_s16le -f data - > SomeFile.txt

as text
 ffmpeg -i in.mp3 -af astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=log.txt -f null -

# Setup:

### Generate fake accounts

  iex -S mix fake_accounts

### image credits


Photo by <a href="https://unsplash.com/@schluditsch?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Daniel Schludi</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

Photo by <a href="https://unsplash.com/@helloimnik?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Hello I'm Nik</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

Photo by <a href="https://unsplash.com/@etiennegirardet?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Etienne Girardet</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

Photo by <a href="https://unsplash.com/@schluditsch?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Daniel Schludi</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
Photo by <a href="https://unsplash.com/@dancristianpaduret?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Dan-Cristian Pădureț</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
Photo by <a href="https://unsplash.com/@grittzheng?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Gritt Zheng</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
