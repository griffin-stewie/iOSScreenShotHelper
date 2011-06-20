//
//  SSHelper.m
//  iOSScreenShotHelper
//
//  Created by griffinstewie on 11/06/20.
//  Copyright 2011 cyanstivy.net. All rights reserved.
//

#import "SSHelper.h"
#import "CSPrefferencesManager.h"

@implementation SSHelper
+ (SSHelper *)sharedInstance {
    static dispatch_once_t pred;
    static SSHelper *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[SSHelper alloc] init];
    });
    return shared;
}


- (id)init
{
    self = [super init];
    if (self != nil) {
    }
    return self;
}


/*
 *	SafariGesturesオリジナルメニューを作成
 */
- (void)setupMenu
{
	NSMenuItem* item;
	
	item = [[NSMenuItem alloc] init];
    
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"SSHelper"];
	[item setSubmenu:menu];
	[item setTitle:[menu title]];
	[[NSApp mainMenu] addItem: item];
	[item release];
	
	item = [[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Crop StatusBar",nil) action:@selector(setCropStatusBar:) keyEquivalent:@""] autorelease];
    [item setTarget:self];
    [item setState:[[CSPrefferencesManager sharedManager] cropStatusBar]];
	[menu addItem:item];
	
	item = [[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Crop NavigationBar",nil) action:@selector(setCropNavigationBar:) keyEquivalent:@""] autorelease];
    [item setTarget:self];
	[menu addItem:item];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
    item = [[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Close Right Tabs",nil) action:@selector(sg_closeRightSideTabs:) keyEquivalent:@""] autorelease];
    [item setTarget:self];
	[menu addItem:item];
    
    [menu setAutoenablesItems:YES];
    [menu release]; menu = nil;
}

- (void)setCropStatusBar:(id)sender
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, @"");
    [[CSPrefferencesManager sharedManager] setCropStatusBar:(BOOL)![sender state]];
    [sender setState:[[CSPrefferencesManager sharedManager] cropStatusBar]];
}

- (void)setCropNavigationBar:(id)sender
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, @"");
    [[CSPrefferencesManager sharedManager] setCropNavigationBar:(BOOL)![sender state]];
    [sender setState:[[CSPrefferencesManager sharedManager] cropNavigationBar]];
}
@end
