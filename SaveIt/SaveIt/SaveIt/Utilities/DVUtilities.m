//
//  DVUtilities.m
//  SaveIt
//
//  Created by Bhagya on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVUtilities.h"

@implementation DVUtilities
+(NSString *)getDocumentsDirectory
{
	static NSString *documentsDirectory = nil;
	if( !documentsDirectory )
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsDirectory = [paths objectAtIndex:0];	   	
	}
	return documentsDirectory;
}

+(void)moveIconsDirectory
{
    NSString *iconsDirectory = [self getIconsDirectory];
    BOOL isDir = NO;
    if( ![[NSFileManager defaultManager] fileExistsAtPath:iconsDirectory isDirectory:&isDir]  || !isDir)
    {
        NSString *iconBundlePath = [[NSBundle mainBundle] pathForResource:@"icons" ofType:@""];
        [[NSFileManager defaultManager] moveItemAtPath:iconBundlePath toPath:iconsDirectory error:nil];
    }
}

#define ICONS_DIR_NAME @"icons"

+(NSString *)getIconsDirectory
{
    NSString *documentsDir = [self getDocumentsDirectory];
    NSString *iconsDir = [documentsDir stringByAppendingPathComponent:ICONS_DIR_NAME];
    return iconsDir;
}

@end
