//
//  CSPrefferencesManager.h
//  iOSScreenShotHelper
//
//  Created by griffinstewie on 11/06/05.
//  Copyright 2011 cyanstivy.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CSPrefferencesManager : NSObject {
    NSDictionary *prefs;
}

@property (nonatomic, retain) NSDictionary *prefs;


+ (CSPrefferencesManager *)sharedManager;
+ (NSString *)preferencePath;
- (NSString *)pathForSavingImage;
- (BOOL)shouldCreateDirectoryIfNotExists;
@end
