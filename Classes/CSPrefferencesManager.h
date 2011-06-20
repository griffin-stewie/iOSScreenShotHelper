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
    BOOL cropStatusBar;
}

@property (nonatomic, retain) NSMutableDictionary *prefs;
@property (assign) BOOL cropStatusBar;


+ (CSPrefferencesManager *)sharedManager;
+ (NSString *)preferencePath;
- (NSString *)pathForSavingImage;
- (BOOL)shouldCreateDirectoryIfNotExists;


- (void)setCropNavigationBar:(BOOL)aBool;
- (BOOL)cropNavigationBar;
@end
