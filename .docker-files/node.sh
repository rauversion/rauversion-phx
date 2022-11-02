set -x

# Add NodeJS to sources list
# curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -
# curl -sL https://deb.nodesource.com/setup_18.x | bash -

curl -fsSL https://deb.nodesource.com/setup_16.x | bash - &&\
apt-get install -y nodejs

# apt-get install -y nodejs #to install Node.js 18.x and npm

#17 10.80 ## You may also need development tools to build native addons:
#apt-get install gcc g++ make
#17 10.80 ## To install the Yarn package manager, run:
#curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
#echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
#apt-get update && apt-get install yarn

#npm install --global yarn

#corepack enable
#echo yarn -v 

# yarn install
