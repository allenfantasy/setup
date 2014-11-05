#!/bin/sh

### install prerequisites
sudo apt-get update
sudo apt-get install -y wget vim build-essential openssl libreadline6 libreadline6-dev libsqlite3-dev libmysqlclient-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt1-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev language-pack-zh-hans python-software-properties

### install nginx
sudo apt-get install -y nginx

### install nodejs
git clone https://github.com/creationix/nvm.git ~/.nvm
echo 'export NVM_DIR="/home/deployer/.nvm"' >> ~/.profile
echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.profile

# build up registry
cp npmrc ~/.npmrc

# load nvm immediately
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

NVM_NODEJS_ORG_MIRROR=http://dist.u.qiniudn.com nvm install 0.10
nvm alias default 0.10

npm install -g pm2@0.9.6

### record current dir
dir=`pwd`

### setup gitrepos
mkdir ~/gitrepos
cd ~/gitrepos
git init --bare meiya.git
cd meiya.git/hooks
cp $dir/post-receive post-receive

# make directories for app
mkdir ~/logs
mkdir -p ~/apps/meiya-node

# about nginx
./nginx.sh
