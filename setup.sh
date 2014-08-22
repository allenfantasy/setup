# setup user & ssh
adduser deployer -ingroup sudo
mkdir .ssh

# install prerequisites
sudo apt-get update
sudo apt-get install -y wget vim build-essential openssl openssl-server libreadline6 libreadline6-dev libsqlite3-dev libmysqlclient-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev language-pack-zh-hans python-software-properties

# install nginx
sudo apt-get install -y nginx

# install nodejs
git clone https://github.com/creationix/nvm.git
echo "source ~/nvm/nvm.sh" >> .bashrc
cp npmrc ~/.npmrc # build up registry
NVM_NODEJS_ORG_MIRROR=http://dist.u.qiniudn.com nvm install 0.10
