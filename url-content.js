// phantomjs url-content.js <url>

var system = require('system');
var address;

//phantom.onError = function(msg, trace) {
//    var msgStack = ['PHANTOM ERROR: ' + msg];
//    if (trace && trace.length) {
//	msgStack.push('TRACE:');
//	trace.forEach(function(t) {
//    	    msgStack.push(' -> ' + (t.file || t.sourceURL) + ': ' + t.line + (t.function ? ' (in function ' + t.function +')' : ''));
//	});
//    }
//    console.error(msgStack.join('\n'));
//    console.error("Error.");
//    hantom.exit(1);
//};

if (system.args.length === 1) {
    console.log('Usage: url-content <some URL>');
    phantom.exit(1);
} else {
    address = system.args[1];
    var webPage = require('webpage');
    var page = webPage.create();

    page.onResourceTimeout = function(request) {
	console.log('Timeout! Response (#' + request.id + '): ' + JSON.stringify(request));
	phantom.exit(1);
    };
    
    page.open(address, function (status) {
        if(status === "success") {
	    var content = page.content;
	    console.log(content);
	    phantom.exit(0);
	}else{
	    console.error("Page.open - " + status);
	    phantom.exit(1);
	}
    });
}  