'use strict';

var TestPlugin = window.TestPlugin || {};

window.TestPlugin.run = function(filename) {
    window.setTimeout(function() {
        _TestPlugin_.done("This is the test result: " + filename);
    }, 5000);
    return "ok!";
}

window.TestPlugin = TestPlugin;

1;