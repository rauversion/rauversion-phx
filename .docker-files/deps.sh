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
    zlib1g-dev \
    apt-transport-https \
    ca-certificates \
    libgnutls30  
    #software-properties-common

#add-apt-repository ppa:chris-needham/ppa
#apt-get update
#apt-get install audiowaveform
