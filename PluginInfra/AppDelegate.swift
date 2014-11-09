//
//  AppDelegate.swift
//  PluginInfra
//
//  Created by Olegs on 06/11/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

import Cocoa
import WebKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet var webView: WebView!
    @IBOutlet var inputText: NSTextView!
    @IBOutlet var outputText: NSTextView!
    
    let jsPlugins : NSMutableArray = NSMutableArray()
    
    @IBAction func executeJS(sender: AnyObject) {
        let jsString = inputText.textStorage?.string
        let js_window = webView.windowScriptObject
        js_window.setValue(self, forKey: "AppDelegate");
        var res : NSString = webView.stringByEvaluatingJavaScriptFromString(
            jsString
        )
        if res.length == 0 { res = "<empty>" }
        var curVal = outputText.textStorage?.string
        if curVal == nil { curVal = "" }
        let newStr : NSString = curVal! + res + "\n"
        outputText.string = newStr
    }
    
    @IBAction func runPlugins(sender: AnyObject) {
        for i in jsPlugins {
            let plugin = i as JSPlugin
            plugin.run("hello world!");
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        let pluginSourceFiles = NSBundle.mainBundle().pathsForResourcesOfType(".js", inDirectory: ".")
        for item in pluginSourceFiles {
            let pluginSourceFile = item as NSString
            NSLog("%@", pluginSourceFile)
            let plugin : JSPlugin = JSPlugin(webView: webView, sourceFile: pluginSourceFile)
            jsPlugins.addObject(plugin)
        }
        NSLog("window.ready")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

