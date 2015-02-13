#!/usr/bin/env node

var program = require('commander');
var async = require('async');
var fs = require('fs');
var config = require('./app.config');

function buildFiles(params) {
  var template;

  // nginx config
  template = fs.readFileSync('templates/nginx-config').toString();
  template = template.replace(new RegExp("%USER%", "g"), params.user);
  template = template.replace(new RegExp("%PORT%", "g"), params.port);
  template = template.replace(new RegExp("%APP_NAME%", "g"), params.name);
  template = template.replace(new RegExp("%PUBLIC_PATH%", "g"), params.public_path);
  fs.writeFileSync('output/' + params.name, template);

  // nginx deploy script
  template = fs.readFileSync('templates/nginx.sh').toString();
  template = template.replace(new RegExp("%APP_NAME%", "g"), params.name);
  fs.writeFileSync('output/nginx.sh', template);

  // post-receive hook
  template = fs.readFileSync('templates/post-receive').toString();
  template = template.replace(new RegExp("%USER%", "g"), params.user);
  template = template.replace(new RegExp("%APP_PATH%", "g"), params.app_path);
  template = template.replace(new RegExp("%APP_NAME%", "g"), params.name);
  fs.writeFileSync('output/post-receive', template);
}

program
  .version('0.0.1')
  .option('-u, --user [value]', 'User')
  .option('-n, --app_name [value]', 'App name')
  .option('-c, --code_path [value]', 'App code base path')
  .option('-p, --public_path [value]', 'App public path')
  .option('-P, --port <n>', 'App port', parseInt)
  .parse(process.argv);

var params = {
  user: program.user || config.user,
  name: program.app_name || config.app_name,
  port: program.port || config.app_port,
  app_path: program.code_path || config.app_path,
  public_path: program.public_path || config.public_path
};

// Cleanup first
fs.readdir('output', function(err, files) {
  async.each(files, function(file, cb) {
    fs.unlink('output/' + file, cb);
  }, function(err) {
    if (err) {
      console.log(err);
      console.log('something is wrong');
      return;
    }
    buildFiles(params);
  });
});

