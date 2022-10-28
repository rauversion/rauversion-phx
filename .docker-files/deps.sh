set -x

# Install Dependencies
apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    vim \
    imagemagick \
    zlib1g-dev \
    apt-transport-https \
    ca-certificates \
    libgnutls30
