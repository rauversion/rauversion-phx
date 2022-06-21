FROM elixir:1.13.4

RUN apt update
RUN apt install -y nodejs npm
RUN npm install --global yarn
RUN apt install -y inotify-tools

RUN mix local.hex --force
RUN apt-get install -y ffmpeg

WORKDIR /app
