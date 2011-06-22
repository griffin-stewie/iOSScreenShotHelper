//
//  iOSScreenShotHelperLoader.m
//  iOSScreenShotHelper
//
//  Created by griffinstewie on 11/06/05.
//  Copyright 2011 cyanstivy.net. All rights reserved.
//

#import "iOSScreenShotHelperLoader.h"
#import "CSPrefferencesManager.h"
#import <objc/objc-runtime.h>
#import <QuartzCore/QuartzCore.h>

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
    [[SSHelper sharedInstance] setupMenu];
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
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
//    NSLog(@"%s %@", __PRETTY_FUNCTION__, paths);
//    if ([paths count] > 0) {
//        NSString *path = [paths objectAtIndex:0];
//        return [NSString stringWithFormat:@"%@/%@", path, aFileName];
//    }
    
    NSString *path = [[[CSPrefferencesManager sharedManager] pathForSavingImage] stringByExpandingTildeInPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
	}
    
    return [NSString stringWithFormat:@"%@/%@", path, aFileName];
}

- (void)saveImageData:(NSData *)imageData
{
    NSString *path = [self pathForSavingImageWithFileName:[self filename]];
    
    if (path == nil) {
        return ;
    }
    
    [imageData writeToFile:path atomically:YES];    
}

- (void)saveImageData:(NSData *)imageData croppingRect:(CGRect)aRect
{
    CIImage *image = [[CIImage alloc] initWithData:imageData];
    CIImage *croppedImage = [image imageByCroppingToRect:aRect];
    NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCIImage:croppedImage];
    NSDictionary *properties = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                           forKey:NSImageInterlaced];
    imageData = [bitmapImageRep representationUsingType:NSPNGFileType
                                             properties:properties];
    
    [bitmapImageRep release]; bitmapImageRep = nil;
    [image release]; image = nil;
    
    [self saveImageData:imageData];
}

- (CGFloat)scaleFromSize:(NSSize)size
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, NSStringFromSize(size));
    CGFloat scale = 1.0f;
    
    if (size.height == (480 * 2) && size.width == (320 * 2)) {
        scale = 2.0f;
    }
    
    return scale;
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

    NSImage *nsImage = [[[NSImage alloc] initWithData:imageData] autorelease];
    NSSize size = [nsImage size];
    CGFloat scale = [self scaleFromSize:size];
    CGRect croppingRect = CGRectMake(0, 0, size.width, size.height);

    if ([[CSPrefferencesManager sharedManager] cropNavigationBar]) {
        croppingRect.size.height -= ((20 * scale) + (44 * scale));
    } else if ([[CSPrefferencesManager sharedManager] cropStatusBar]) {
        croppingRect.size.height -= (20 * scale);
    } 
    
    if ([[CSPrefferencesManager sharedManager] cropTabBar]) {
        CGFloat barHeight = 49;
        croppingRect.origin.y = (barHeight * scale);
        croppingRect.size.height -= (barHeight * scale);
    } else if ([[CSPrefferencesManager sharedManager] cropToolBar]) {
        CGFloat barHeight = 44;
        croppingRect.origin.y = (barHeight * scale);
        croppingRect.size.height -= (barHeight * scale);
    } 

    NSLog(@"%s %@", __PRETTY_FUNCTION__, NSStringFromRect(NSRectFromCGRect(croppingRect)));
    
    [self saveImageData:imageData croppingRect:croppingRect];
}
@end



