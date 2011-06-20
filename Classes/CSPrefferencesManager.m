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

@implementation CSPrefferencesManager

@synthesize prefs;


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
			self.prefs = [NSDictionary dictionaryWithContentsOfFile:path];
        }
    }
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

@end
