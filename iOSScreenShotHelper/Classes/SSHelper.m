//
//  SSHelper.m
//  iOSScreenShotHelper
//
//  Created by griffinstewie on 11/06/20.
//  Copyright 2011 cyanstivy.net. All rights reserved.
//

#import "SSHelper.h"
#import "CSPrefferencesManager.h"

@interface SSHelper ( )
- (void)setCropToolBar:(id)sender;
- (void)setCropTabBar:(id)sender;
- (void)setCropStatusBar:(id)sender;
- (void)setCropNavigationBar:(id)sender;
@end


@implementation SSHelper
+ (SSHelper *)sharedInstance {
    static dispatch_once_t pred;
    static SSHelper *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[SSHelper alloc] init];
    });
    return shared;
}

#pragma mark -
#pragma mark Menu

- (void)setupMenu
{
	NSMenuItem* item;
	
	item = [[[NSMenuItem alloc] init] autorelease];
    
    NSMenu *menu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"SSHelper", nil)];
	[item setSubmenu:menu];
	[item setTitle:[menu title]];
	[[NSApp mainMenu] addItem: item];
	
	item = [[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Crop StatusBar",nil) action:@selector(setCropStatusBar:) keyEquivalent:@""] autorelease];
    [item setTarget:self];
    [item setState:[[CSPrefferencesManager sharedManager] cropStatusBar]];
	[menu addItem:item];
	
	item = [[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Crop NavigationBar",nil) action:@selector(setCropNavigationBar:) keyEquivalent:@""] autorelease];
    [item setTarget:self];
    [item setState:[[CSPrefferencesManager sharedManager] cropNavigationBar]];
	[menu addItem:item];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Crop TabBar",nil) action:@selector(setCropTabBar:) keyEquivalent:@""] autorelease];
    [item setTarget:self];
    [item setState:[[CSPrefferencesManager sharedManager] cropTabBar]];
	[menu addItem:item];
    
    item = [[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Crop ToolBar",nil) action:@selector(setCropToolBar:) keyEquivalent:@""] autorelease];
    [item setTarget:self];
    [item setState:[[CSPrefferencesManager sharedManager] cropToolBar]];
	[menu addItem:item];
    
    [menu setAutoenablesItems:YES];
    [menu release]; menu = nil;
}



- (NSMenuItem *)helperMenuItem
{
    NSMenuItem *item = [[NSApp mainMenu] itemWithTitle:NSLocalizedString(@"SSHelper", nil)];
    return item;
}

- (NSMenuItem *)cropTabBarMenuItem
{
    NSMenuItem *item = nil;
    item = [self helperMenuItem];
    item = [[item submenu] itemWithTitle:NSLocalizedString(@"Crop TabBar",nil)];
    return item;
}

- (NSMenuItem *)cropToolBarMenuItem
{
    NSMenuItem *item = nil;
    item = [self helperMenuItem];
    item = [[item submenu] itemWithTitle:NSLocalizedString(@"Crop ToolBar",nil)];
    return item;
}

- (void)updateMenuItem
{
    NSMenuItem *cropTabBarMenuItem = [self cropTabBarMenuItem];
    NSMenuItem *cropToolBarMenuItem = [self cropToolBarMenuItem];
    [cropTabBarMenuItem setState:NSOffState];
    [cropToolBarMenuItem setState:NSOffState];
    
    if ([[CSPrefferencesManager sharedManager] cropTabBar]) {
        [cropTabBarMenuItem setState:NSOnState];
    } else if ([[CSPrefferencesManager sharedManager] cropToolBar]) {
        [cropToolBarMenuItem setState:NSOnState];
    }
}

#pragma mark -
#pragma mark Menu Action

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

- (void)setCropTabBar:(id)sender
{
    BOOL flag = (BOOL)![(NSMenuItem *)sender state];
    
    [[CSPrefferencesManager sharedManager] setCropTabBar:flag];

    if (flag) {
        [[CSPrefferencesManager sharedManager] setCropToolBar:!flag];
    }

    [self updateMenuItem];
}

- (void)setCropToolBar:(id)sender
{
    BOOL flag = (BOOL)![(NSMenuItem *)sender state];
    
    [[CSPrefferencesManager sharedManager] setCropToolBar:flag];
    
    if (flag) {
        [[CSPrefferencesManager sharedManager] setCropTabBar:!flag];
    }

    [self updateMenuItem];
}
@end
