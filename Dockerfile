# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian instead of
# Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20220801-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.13.4-erlang-25.0.4-debian-bullseye-20220801-slim
#
ARG ELIXIR_VERSION=1.13.4
ARG OTP_VERSION=25.0.4
ARG DISTRO=ubuntu
ARG DEBIAN_VERSION=bionic-20210930
ARG DEFAULT_LOCALE=en

ARG PG_MAJOR=14
ARG NODE_MAJOR=18
ARG YARN_VERSION=1.13.0

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-${DISTRO}-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="${DISTRO}:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder


# Copy Installers
RUN mkdir -p /docker-files
COPY .docker-files/ /docker-files
RUN chmod +x /docker-files/*.sh

# Install Dependencies
RUN /docker-files/deps.sh

# Install PostgreSQL
# RUN /docker-files/pg.sh

RUN apt-get install -y postgresql-client

# Install NodeJS, Yarn
RUN /docker-files/node.sh

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"
ENV DEFAULT_LOCALE $DEFAULT_LOCALE


# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv

COPY lib lib

COPY assets assets


RUN echo yarn -v

RUN cd ./assets ; npm install
# compile assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}


RUN apt-get update -y && apt-get install -y libstdc++6 openssl \ 
  libncurses5 locales \
  imagemagick 

COPY --from=mwader/static-ffmpeg:4.1.4-2 /ffmpeg /ffprobe /usr/local/bin/

# Audiowaveform
RUN apt install software-properties-common -y && \ 
  apt-get update && \
  add-apt-repository ppa:chris-needham/ppa && \ 
  apt-get update && \
  apt-get install audiowaveform -y

RUN apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG "en_US.UTF-8"
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/rauversion ./

USER nobody

CMD ["/app/bin/server"]