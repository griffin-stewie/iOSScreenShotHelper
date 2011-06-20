//
//  CSPrefferencesManager.m
//  iOSScreenShotHelper
//
//  Created by griffinstewie on 11/06/05.
//  Copyright 2011 cyanstivy.net. All rights reserved.
//

#import "CSPrefferencesManager.h"

NSString * const kScreenShotSaveFilePath = @"ScreenShotSaveFilePath";
NSString * const kCreateDirectoryIfNotExists = @"CreateDirectoryIfNotExists";
NSString * const kCropStatusBar = @"CropStatusBar";
NSString * const kCropNavigationBar = @"CropNavigationBar";

@implementation CSPrefferencesManager

@synthesize prefs;
@synthesize cropStatusBar;


+ (NSString *)preferencePath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString* path = nil;
    if ([paths count] > 0) {
        path  = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"iOSScreenShotHelper/iOSScreenShotHelper.plist"];
    }
	return path;
}

+ (void)initialize {
    NSString *path = [self preferencePath];
	if (!path) {
		return;
	}
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return;
    }
    
	NSString *directory = [path stringByDeletingLastPathComponent];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:directory]) {
        NSError *error = nil;
		[fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
	}
    
	NSMutableDictionary *prefs = [NSMutableDictionary dictionary];
    [prefs setObject:@"~/Desktop/iOSScreenShots" forKey:kScreenShotSaveFilePath];
    [prefs setObject:[NSNumber numberWithBool:YES] forKey:kCreateDirectoryIfNotExists];
    [prefs writeToFile:path atomically:YES];
}

+ (CSPrefferencesManager *)sharedManager {
    static dispatch_once_t pred;
    static CSPrefferencesManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[CSPrefferencesManager alloc] init];
    });
    return shared;
}

- (void)load
{
    NSString *path = [[self class] preferencePath];
	if (path) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if ([fileManager fileExistsAtPath:path]) {
			self.prefs = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        }
    }
}

- (void)save
{
    NSString *path = [[self class] preferencePath];
    [prefs writeToFile:path atomically:YES];
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self load];
    }
    return self;
}

- (void)dealloc
{
    [prefs release], prefs = nil;

    [super dealloc];
}


- (NSString *)pathForSavingImage
{
    return [self.prefs objectForKey:kScreenShotSaveFilePath];
}

- (BOOL)shouldCreateDirectoryIfNotExists
{
    return [[self.prefs objectForKey:kCreateDirectoryIfNotExists] boolValue];
}

- (void)setCropStatusBar:(BOOL)aBool
{
    if (cropStatusBar != aBool) {
        cropStatusBar = aBool;
        [self.prefs setObject:[NSNumber numberWithBool:aBool] forKey:kCropStatusBar];
        [self save];
    }
}

- (BOOL)cropStatusBar
{
    NSNumber *num = [self.prefs objectForKey:kCropStatusBar];
    return [num boolValue];
}

- (void)setCropNavigationBar:(BOOL)aBool
{
    [self.prefs setObject:[NSNumber numberWithBool:aBool] forKey:kCropNavigationBar];
    [self save];
}

- (BOOL)cropNavigationBar
{
    NSNumber *num = [self.prefs objectForKey:kCropNavigationBar];
    return [num boolValue];
}
@end
