// ./phantomjs/bin test1.js <url> - выдает на STDOUT содержимое страницы.
// Тестовый скрипт. Только для демонстрации. 
// В работе не должен использоваться - может меняться. Для работы используются свои скрипты.

var system = require('system');
var address;

if (system.args.length === 1) {
    console.log('Usage: loadspeed.js <some URL>');
    phantom.exit(1);
} else {

    address = system.args[1];
	var webPage = require('webpage');
	var page = webPage.create();

  page.open(address, function (status) {
	if(status === "success") {
  	  //page.render('sample.png');
  	  
  	  //1:
  	  //page.evaluate();
  	  var content = page.content;
	  console.log('Content: ' + content);
	  
	  
		
	}else{
	  console.log(status);
	}
	phantom.exit();
  });

}  