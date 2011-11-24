//
//  PMAppDelegate.h
//  PandoraMan
//
//  Created by Josh Ellithorpe on 11/22/11.
//  Copyright (c) 2011 IntrArts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#define PandoraURL @"http://www.pandora.com"

@interface PMAppDelegate : NSObject <NSApplicationDelegate>
{
  IBOutlet id pandoraView;
  NSMutableSet *otherWebViews;
}

- (IBAction)playMenu:(id)sender;
- (IBAction)nextMenu:(id)sender;
- (IBAction)likeMenu:(id)sender;
- (IBAction)dislikeMenu:(id)sender;
- (BOOL)simulateClick: (int)keyCode withModifiers:(int)modifiers;

- (void)addOtherWebView:(WebView *)theView;
- (void)removeOtherWebView:(WebView *)theView;

@property (assign) IBOutlet NSWindow *window;

@end
