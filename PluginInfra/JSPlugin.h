//
//  JSPlugin.h
//  PluginInfra
//
//  Created by Olegs on 07/11/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#define WB_PLUGIN_URL_SCHEMA_PREFFIX "Whitebox-plugin:"

@interface JSPlugin : NSObject

@property (nonatomic, weak, readwrite)  id        delegate;
@property (nonatomic, strong, readonly) WebView  *webView;
@property (nonatomic, strong, readonly) NSString *name;

- (id)         initWithWebView:(WebView *)webView sourceFile:(NSString *)sourceFile;
- (void)       run:(NSString *)data;
- (void)       undefinedJSMethodInvoked;
- (NSString *) pluginURLSchema;
- (void)       done:(NSString *)data;
- (void)       fail:(NSString *)error;

+ (BOOL)       isSelectorExcludedFromWebScript:(SEL)aSelector;
+ (BOOL)       isKeyExcludedFromWebScript:(const char *)name;

@end
