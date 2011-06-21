//
//  CSPrefferencesManager.h
//  iOSScreenShotHelper
//
//  Created by griffinstewie on 11/06/05.
//  Copyright 2011 cyanstivy.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CSPrefferencesManager : NSObject {
    NSMutableDictionary *prefs;
}

@property (nonatomic, retain) NSMutableDictionary *prefs;


+ (CSPrefferencesManager *)sharedManager;
+ (NSString *)preferencePath;
- (NSString *)pathForSavingImage;
- (BOOL)shouldCreateDirectoryIfNotExists;

- (void)setCropStatusBar:(BOOL)aBool;
- (BOOL)cropStatusBar;

- (void)setCropNavigationBar:(BOOL)aBool;
- (BOOL)cropNavigationBar;

- (void)setCropTabBar:(BOOL)aBool;
- (BOOL)cropTabBar;

- (void)setCropToolBar:(BOOL)aBool;
- (BOOL)cropToolBar;
@end
