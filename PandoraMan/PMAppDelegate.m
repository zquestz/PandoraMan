//
//  PMAppDelegate.m
//  PandoraMan
//
//  Created by Josh Ellithorpe on 11/22/11.
//  Copyright (c) 2011 IntrArts. All rights reserved.
//

#import "PMAppDelegate.h"

@implementation PMAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject: [NSNumber numberWithBool:YES] forKey:@"WebKitDeveloperExtras"]];
  [pandoraView setHostWindow:_window];
  [pandoraView setPolicyDelegate:self];
  [pandoraView setUIDelegate:self];
  [pandoraView setFrameLoadDelegate:self];
  [pandoraView setGroupName:@"PandoraMan"];
  [pandoraView setShouldUpdateWhileOffscreen:YES];
  [[pandoraView preferences] setJavaScriptCanOpenWindowsAutomatically:YES];
  [[pandoraView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PandoraURL]]];
}

// If this gets called from our main view, load the url there, otherwise pop in new window.
- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
  if( [sender isEqual:pandoraView] ) {
    [listener use];
  }
  else {
    [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    [self removeOtherWebView:sender];
    [listener ignore];
  }
}

// All new window actions load in the browser.
- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener
{
  [[NSWorkspace sharedWorkspace] openURL:[request URL]];
  [self removeOtherWebView:sender];
  [listener ignore];
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
  // Report feedback only for the main frame.
  if (frame == [sender mainFrame]){
    [[sender window] setTitle:title];
  }
}

// Required so that javascript window.open calls work.
// Thanks to PandoraBoy for providing some assistance in this area.
- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{   
  WebView *newWebView = [[WebView alloc] init];
  [newWebView setUIDelegate:self];
  [newWebView setPolicyDelegate:self];
  [self addOtherWebView:newWebView];
  return newWebView;
}

- (void)addOtherWebView:(WebView *)theView
{
  if (!otherWebViews) {
    otherWebViews = [[NSMutableSet alloc] initWithCapacity:1];
  }
  [otherWebViews addObject:theView];
}

- (void)removeOtherWebView:(WebView *)theView
{
  [otherWebViews removeObject:theView];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication 
{
  return YES;
}

- (BOOL)simulateClick: (int)keyCode withModifiers:(int)modifiers
{
  // No modifier support yet.
  CGEventRef keyPressEvent=CGEventCreateKeyboardEvent (NULL, (CGKeyCode)keyCode, true);
  CGEventRef keyPressUpEvent=CGEventCreateKeyboardEvent (NULL, (CGKeyCode)keyCode, false);
  CGEventPost(kCGAnnotatedSessionEventTap, keyPressEvent);
  CGEventPost(kCGAnnotatedSessionEventTap, keyPressUpEvent);
  CFRelease(keyPressEvent);
  CFRelease(keyPressUpEvent);
  return true;
}

- (IBAction)playMenu:(id)sender
{
  [self simulateClick:49 withModifiers:0];
}

- (IBAction)nextMenu:(id)sender
{
  [self simulateClick:124 withModifiers:0];
}

- (IBAction)likeMenu:(id)sender
{
  [self simulateClick:69 withModifiers:0];
}

- (IBAction)dislikeMenu:(id)sender
{
  [self simulateClick:78 withModifiers:0];
}

@end
