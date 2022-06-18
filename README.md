# Rauversion

## setup
  
You can develop directly in a container with [vscode devcontainer](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) or [neovim devcontainer](https://github.com/jamestthompson3/nvim-remote-containers)
  
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Create some fake accounts `mix fake_accounts`
  * Compile assets `cd assets && yarn install & cd ..`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## images

https://unsplash.com/photos/eXVd7gDPO9A
https://unsplash.com/photos/mbGxz7pt0jM
