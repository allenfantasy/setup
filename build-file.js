var fs = require('fs');
var config = require('app.config');
var template;

// nginx config
template = fs.readFileSync('templates/template.nginx-config').toString();
template = template.replace(new RegExp("%PORT%", "g"), config.app_port);
template = template.replace(new RegExp("%APP_NAME%", "g"), config.app_name);
template = template.replace(new RegExp("%PUBLIC_PATH%", "g"), config.public_path);
fs.writeFileSync(config.app_name + '.nginx-config', template);
//console.log(template);

// post-receive hook
template = fs.readFileSync('templates/template.post-receive').toString();
template = template.replace(new RegExp("%APP_PATH%", "g"), config.app_path);
template = template.replace(new RegExp("%APP_NAME%", "g"), config.app_name);
fs.writeFileSync('post-receive', template);
//console.log(template);
