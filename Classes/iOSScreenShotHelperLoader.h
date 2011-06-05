//
//  iOSScreenShotHelperLoader.h
//  iOSScreenShotHelper
//
//  Created by griffinstewie on 11/06/05.
//  Copyright 2011 cyanstivy.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iOS.h"

@interface iOSScreenShotHelperLoader : NSObject  
+ (void)install;
@end

@interface MonitorController (SwizzlingAdditions)
- (void)cs_copyScreen:(id)arg1;
+ (void)_swizzleMethods;
@end
