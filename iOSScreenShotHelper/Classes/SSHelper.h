//
//  SSHelper.h
//  iOSScreenShotHelper
//
//  Created by griffinstewie on 11/06/20.
//  Copyright 2011 cyanstivy.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SSHelper : NSObject {

}
+ (SSHelper *)sharedInstance;
- (void)setupMenu;
@end
