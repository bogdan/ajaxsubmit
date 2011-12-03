var fs = require('fs');

var files = ["form-errors.js.coffee", "ajax-submit.js.coffee"];
var source = "";

var CoffeeScript = eval(fs.readFileSync("vendor/coffee-script.js", 'utf-8'));
files.forEach(function(name){
  source += fs.readFileSync("src/" + name);
});

var banner = fs.readFileSync("src/banner.js", "utf-8");
fs.writeFile("ajaxsubmit.js", banner + CoffeeScript.compile(source), function(err) {
  if (err) throw err;
});
