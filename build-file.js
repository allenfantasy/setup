#!/usr/bin/env node

var fs = require('fs');
var config = require('./app.config');
var template;

// nginx config
template = fs.readFileSync('templates/nginx-config').toString();
template = template.replace(new RegExp("%PORT%", "g"), config.app_port);
template = template.replace(new RegExp("%APP_NAME%", "g"), config.app_name);
template = template.replace(new RegExp("%PUBLIC_PATH%", "g"), config.public_path);
fs.writeFileSync('output/' + config.app_name, template);

// nginx deploy script
template = fs.readFileSync('templates/nginx.sh').toString();
template = template.replace(new RegExp("%APP_NAME%", "g"), config.app_name);
fs.writeFileSync('output/nginx.sh', template);

// post-receive hook
template = fs.readFileSync('templates/post-receive').toString();
template = template.replace(new RegExp("%APP_PATH%", "g"), config.app_path);
template = template.replace(new RegExp("%APP_NAME%", "g"), config.app_name);
fs.writeFileSync('output/post-receive', template);
