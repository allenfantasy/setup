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
sudo chmod a+x $dir/post-receive
cp $dir/post-receive post-receive

# make directories for app
mkdir ~/logs
mkdir -p ~/$app_folder

# config nginx
cd $dir
sudo chmod a+x ./nginx.sh
./nginx.sh
