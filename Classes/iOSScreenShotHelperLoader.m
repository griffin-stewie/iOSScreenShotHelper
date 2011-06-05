//
//  iOSScreenShotHelperLoader.m
//  iOSScreenShotHelper
//
//  Created by griffinstewie on 11/06/05.
//  Copyright 2011 cyanstivy.net. All rights reserved.
//

#import "iOSScreenShotHelperLoader.h"
#import <objc/objc-runtime.h>

void exchangeImpl(Class class, SEL original, SEL replaced)
{
	Method originalMethod = class_getInstanceMethod(class, original);
	if (originalMethod == NULL) {
		return;
	}
    Method swizzledMethod = class_getInstanceMethod(class, replaced);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@implementation iOSScreenShotHelperLoader
+ (void)install
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, @"iOSScreenShotHelperLoader");    
    Class origClass = NSClassFromString(@"MonitorController");
    [origClass _swizzleMethods];
}
@end


@implementation MonitorController (SwizzlingAdditions)

+ (void)_swizzleMethods
{
    exchangeImpl(NSClassFromString(@"MonitorController"), 
                 @selector(copyScreen:), 
                 @selector(cs_copyScreen:));
}

- (NSString *)dateString
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY_MM_dd_hh_mm_ss"];
    NSString *dateString = [formatter stringFromDate:now];
    NSLog(@"%s %@", __PRETTY_FUNCTION__, dateString);
    [formatter release]; formatter = nil;
    return dateString;    
}

- (NSString *)filename
{
    NSString *prefix = @"ScreenShot";
    return [NSString stringWithFormat:@"%@_%@.png", prefix, [self dateString]];
}

- (NSString *)pathForSavingImageWithFileName:(NSString *)aFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSLog(@"%s %@", __PRETTY_FUNCTION__, paths);
    if ([paths count] > 0) {
        NSString *path = [paths objectAtIndex:0];
        return [NSString stringWithFormat:@"%@/%@", path, aFileName];
    }
    return nil;
}

- (void)cs_copyScreen:(id)arg1
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, @"");
    [self cs_copyScreen:arg1];
    
    NSData * imageData;
    
    imageData = [[NSPasteboard generalPasteboard] dataForType:NSTIFFPboardType];

    if (imageData == nil) {
        return;
    }
    
    NSString *path = [self pathForSavingImageWithFileName:[self filename]];

    if (path == nil) {
        return ;
    }
    
    [imageData writeToFile:path atomically:YES];
}
@end



