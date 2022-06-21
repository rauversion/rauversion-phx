FROM elixir:1.13.4

RUN apt update
RUN apt install -y nodejs npm
RUN npm install --global yarn
RUN apt install -y inotify-tools

RUN mix local.hex --force
RUN apt install -y ffmpeg
RUN apt install -y libmad0-dev libid3tag0-dev libsndfile1-dev libgd-dev
RUN apt install -y lame

WORKDIR /app
