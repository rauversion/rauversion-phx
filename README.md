# Rauversion

---

![image](https://user-images.githubusercontent.com/11976/174422926-b392a1f5-bd6a-4bd2-b6c8-8d41dad6711d.png)

[![.github/workflows/ci.yml](https://github.com/rauversion/rauversion-phx/actions/workflows/ci.yml/badge.svg)](https://github.com/rauversion/rauversion-phx/actions/workflows/ci.yml)

Rauversion is an open source music sharing platform.

Rauversion is built on Elixir with Phoenix framework.


## Features:
 + Account system with different providers, Twitter, Discord, Twitch.
 + Roles to open or closed communities.
### Music publishing:
  + Audio processing to format mp3 and audio analisis to draw audio peaks.
  + Audio player, embeddable, with chunk range loading processing to save bandwidth.
  + Music publishing preferences, downloadable, private, attribution settings, like cretive commons , all right reserved.
  + Uploads for tracks, albums and playlists with their meta information.
  + Multi upload provider local or aws, other providers could be inmplemented.
  + Sellable tracks & albums with Stripe, for connected accounts or main account.
  + Tagging tracks, playlist & albums.
### Music Listening:
  + Follow artists
  + Make playlists & reposts
  + Comments on tracks and albums.

### Events: 
  + Event scheduling
  + Host & managers
  + Ticketing service with QR validation
  + Sell event tickets via stripe or transbank (Chile).
  + Use Stripe connect to ease the payouts.
  + Streaming services via Twitch, Zoom, Whereby, Mux and Stream Yard.
  + Attendees event details.
  + Public page with ticket checkout for paid or free tickets.

### Publishing magazine:
  + Articles managment publishing: Draft, Public, Listed and partially public.
  + Showcase articles in homepage.
  + Text editor based on [Dante3](https://dante-editor.dev)
  + Cover image.
  + Article Categories.
  


## setup

Rauversion is written in Elixir on top of the Phoenix Framework:

> OTP 25 and elixir 1.13.4 and up is required

You can develop directly in a container with [vscode devcontainer](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) or [neovim devcontainer](https://github.com/jamestthompson3/nvim-remote-containers)

To start your Rauversion server:

  * Install dependencies with `mix deps.get`
  * rename `.env.example` to `.env` and add your variable configurations
  * Create and migrate your database with `mix ecto.setup`
  * Compile assets `cd assets && yarn install & cd ..`
  * Optionally create some fake accounts `mix fake_accounts`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


### Generate fake accounts

  iex -S mix fake_accounts


### File preprocessing requirements:

+ Lame
+ FFMPEG
+ imagemagick

## Credits


### Flag rendering API:

+ https://flagpedia.net/download/api

### image credits


Photo by <a href="https://unsplash.com/@schluditsch?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Daniel Schludi</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

Photo by <a href="https://unsplash.com/@helloimnik?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Hello I'm Nik</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

Photo by <a href="https://unsplash.com/@etiennegirardet?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Etienne Girardet</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

Photo by <a href="https://unsplash.com/@schluditsch?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Daniel Schludi</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
Photo by <a href="https://unsplash.com/@dancristianpaduret?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Dan-Cristian Pădureț</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
Photo by <a href="https://unsplash.com/@grittzheng?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Gritt Zheng</a> on <a href="https://unsplash.com/s/photos/music-studio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

Photo by <a href="https://unsplash.com/@saiharishk?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Sai Harish</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

Foto de <a href="https://unsplash.com/@denitdao?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Denys Churchyn</a> en <a href="https://unsplash.com/es/s/fotos/black-background-gradient?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
  
  
