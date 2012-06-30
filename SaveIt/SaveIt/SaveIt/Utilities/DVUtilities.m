//
//  DVUtilities.m
//  SaveIt
//
//  Created by Bhagya on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVUtilities.h"
#import "NSString+UDID.h"

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

+ (void)showCameraInViewController:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:viewController];
        [viewController presentModalViewController:imagePicker animated:YES];
    }
}

+ (void)showPhotoLibrary:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController
{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setDelegate:viewController];
        [viewController presentModalViewController:imagePicker animated:YES];
}

+ (void)saveIconFromImage:(UIImage*)image completionBlock:(void (^)(BOOL success, NSString* newFileName))completed
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *uuid = [NSString uuid];
        NSString *absPath = [[[self getIconsDirectory] stringByAppendingPathComponent:uuid] stringByAppendingPathExtension:@"png"];
        BOOL success = [UIImagePNGRepresentation(image) writeToFile:absPath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(success, uuid);
        });
    });
}

@end
