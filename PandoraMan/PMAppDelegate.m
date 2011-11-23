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
  [pandoraView setPolicyDelegate:self];
  [pandoraView setUIDelegate:self];
  [pandoraView setFrameLoadDelegate:self];
  [pandoraView setGroupName:@"PandoraMan"];
  [[pandoraView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PandoraURL]]];
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener
{
  NSURL *url = [actionInformation objectForKey:WebActionOriginalURLKey];
  [[NSWorkspace sharedWorkspace] openURL:url];
  [listener ignore];
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
  // Report feedback only for the main frame.
  if (frame == [sender mainFrame]){
    [[sender window] setTitle:title];
  }
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
