# start nginx
sudo service nginx start
# setup nginx config
sudo cp %APP_NAME% /etc/nginx/sites-enabled
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart
