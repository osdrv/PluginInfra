//
//  JSPlugin.m
//  PluginInfra
//
//  Created by Olegs on 07/11/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "JSPlugin.h"

static NSArray *PLUGIN_JS_METHODS = nil;

@implementation JSPlugin

@synthesize webView = webView_;
@synthesize name = name_;

+ (void) initialize {
    if (!PLUGIN_JS_METHODS) {
        PLUGIN_JS_METHODS = [[NSArray alloc] initWithObjects:
                                                        @"done:",
                                                        @"fail:",
                                                        @"log:",
                                                        nil];
    }
}

+ (BOOL) isSelectorExcludedFromWebScript:(SEL)selector {
    
    NSLog(@"%@ received %@ for '%@'", self, NSStringFromSelector(_cmd), NSStringFromSelector(selector));
    
    if ([PLUGIN_JS_METHODS containsObject:NSStringFromSelector(selector)]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL) isKeyExcludedFromWebScript:(const char *)property {
    NSLog(@"%@ received %@ for '%s'", self, NSStringFromSelector(_cmd), property);
    
    if (strcmp(property, "sharedValue") == 0) {
        return NO;
    }
    
    return YES;
}

+ (NSString *) webScriptNameForSelector:(SEL)selector {
    NSLog(@"%@ received %@ with sel='%@'", self, NSStringFromSelector(_cmd), NSStringFromSelector(selector));
    
    NSUInteger pos = [PLUGIN_JS_METHODS indexOfObject:NSStringFromSelector(selector)];
    
    if (pos == NSNotFound) {
        return nil;
    } else {
        NSString *methodName = [PLUGIN_JS_METHODS objectAtIndex:pos];
        if (!methodName) {
            return nil;
        }
        // Remove the trailing colon
        NSString *jsMethodName = [methodName substringToIndex:[methodName length] - 1];
        
        return jsMethodName;
    }
}

- (id) initWithWebView:(WebView *)webView sourceFile:(NSString *)sourceFile {
    
    if (self = [super init]) {
        webView_ = webView;
        name_    = [[sourceFile lastPathComponent] stringByDeletingPathExtension];
        WebScriptObject *window = webView.windowScriptObject;
        [window setValue:self forKey:[NSString stringWithFormat:@"_%@_", self.name]];
        NSString *sourceCode = [NSString stringWithContentsOfFile:sourceFile encoding:NSUTF8StringEncoding error:nil];
        
        NSString *exportResult = [webView_ stringByEvaluatingJavaScriptFromString:sourceCode];
        NSLog(@"The result of the export: %@", exportResult);
    }
    
    return self;
}

- (void) run:(NSString *)data {
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.%@.run(\"%@\")", self.name, data]];
//    [[self.webView windowScriptObject] callWebScriptMethod:
//        [NSString stringWithFormat:@"%@.run", self.name] withArguments:[NSArray arrayWithObjects:data, nil]
//    ];
}

- (void) done:(NSString *)data {
    NSLog(@"I received the data: %@", data);
    if ([self.delegate respondsToSelector:@selector(pluginDidFinishRun:)]) {
        [self.delegate performSelector:@selector(pluginDidFinishRun:) withObject:data];
    }
}

- (void) fail:(NSString *)error {
    if ([self.delegate respondsToSelector:@selector(pluginDidFailRun:)]) {
        [self.delegate performSelector:@selector(pluginDidFailRun) withObject:error];
    }
}

- (void) undefinedJSMethodInvoked {
    NSLog(@"Undefined JS method called");
}

- (NSString *) pluginURLSchema {
    return [NSString stringWithFormat:@"Whitebox-plugin:%@", self.name];
}

@end
