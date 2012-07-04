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

const float icon_universal_size = 60.0f;
+ (void)saveIconFromImage:(UIImage*)image completionBlock:(void (^)(BOOL success, NSString* newFileName))completed
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *uuid = [[NSString uuid] stringByAppendingPathExtension:@"png"];
        NSString *absPath = [[self getIconsDirectory] stringByAppendingPathComponent:uuid];
        UIGraphicsBeginImageContext(CGSizeMake(icon_universal_size, icon_universal_size));
        CGSize aspectSize = [self aspectRatioSizeForPhotoWithSize:image.size toDestinationSize:CGSizeMake(icon_universal_size, icon_universal_size)];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0, -1.0);
        transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(0.0, icon_universal_size));
        CGContextConcatCTM(UIGraphicsGetCurrentContext(), transform);
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0, 0.0, aspectSize.width, aspectSize.height), image.CGImage);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        BOOL success = [UIImagePNGRepresentation(newImage) writeToFile:absPath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(success, uuid);
        });
    });
}

+ (CGSize)aspectRatioSizeForPhotoWithSize:(CGSize)inSize toDestinationSize:(CGSize)inDestSize
{
	int width = inSize.width;
	int height = inSize.height;
	
	int newWidth, newHeight;
	
	int destWidth = inDestSize.width;
	int destHeight = inDestSize.height;
	
	if(width < height)
    {
		newWidth = destWidth;
		newHeight = height * destWidth / width;
    } 
	else 
    {
		newHeight = destHeight;
		newWidth = width * destHeight / height;
    }
	return CGSizeMake(newWidth, newHeight);
}

@end
