'use strict';

var SecondPlugin = window.SecondPlugin || {};

window.SecondPlugin.run = function(filename) {
    window.setTimeout(function() {
                      _SecondPlugin_.done("This is the test second result: " + filename);
                      }, 2500);
    return "ok!";
}

window.SecondPlugin = SecondPlugin;

1;