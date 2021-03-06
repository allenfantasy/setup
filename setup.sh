#!/bin/sh

### install prerequisites
sudo apt-get update
sudo apt-get install -y wget vim build-essential openssl libreadline6 libreadline6-dev libsqlite3-dev libmysqlclient-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt1-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev language-pack-zh-hans python-software-properties

### install nginx
sudo apt-get install -y nginx

### install mongodb
while true; do
  read -p "Do you want to install MongoDB (y/n)? " answer
  case $answer in
    [Yy]*)
      sudo apt-get -y install mongodb-server
      break
      ;;
    [Nn]*)
      break
      ;;
    *)
      echo "Please answer yes[y/N] or no[n/N]!"
      ;;
  esac
done

### install nodejs
git clone https://github.com/creationix/nvm.git ~/.nvm
#curl https://raw.githubusercontent.com/creationix/nvm/v0.22.1/install.sh | bash
echo 'export NVM_DIR="/home/deployer/.nvm"' >> ~/.profile
echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.profile

# build up registry
cp npmrc ~/.npmrc

# load nvm immediately
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

#NVM_NODEJS_ORG_MIRROR=http://dist.u.qiniudn.com nvm install 0.10

# install pm2
nvm install 0.10.33
nvm alias default 0.10.33
npm install -g pm2@0.9.6

# build nginx config file & post-receive hook
./build-file.js

### record current dir
dir=`pwd`
app_name='turf'
app_folder=~/apps/$app_name
git_folder=$app_name.git

### setup gitrepos
mkdir ~/gitrepos
cd ~/gitrepos
git init --bare $git_folder
cd $git_folder/hooks
cp $dir/post-receive post-receive

# make directories for app
mkdir ~/logs
mkdir -p ~/$app_folder

# config nginx
cd $dir
sudo chmod a+x nginx.sh
./nginx.sh
