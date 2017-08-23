// phantomjs url-content.js <url> <timeout>

var system = require('system');
var address;

if (system.args.length === 2) {
    console.log('Usage: url-content <some URL>');
    phantom.exit(1);
} else {
    address = system.args[1];
    tmout = system.args[2];
    var webPage = require('webpage');
    var page = webPage.create();
    page.settings.resourceTimeout = tmout;

    page.onResourceTimeout = function(request) {
	system.stderr.write('ERROR. Timeout! ' + tmout  + ' msec  (' + address + ')');
	phantom.exit(1);
    };

    page.customHeaders = {
      "Accept-Language": "ru-RU"
    };
        
    page.onInitialized = function() {
          page.customHeaders = {};
    };
    
    page.open(address, function (status) {
        if(status === "success") {
	    var content = page.content;
	    console.log(content);
	    phantom.exit(0);
	}else{
	    system.stderr.write("ERROR. Page.open - " + status + '(' + address + ')');
	    phantom.exit(1);
	}
    });
}  