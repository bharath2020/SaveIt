//
//  DVUtilities.h
//  SaveIt
//
//  Created by Bhagya on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVUtilities : NSObject
+(NSString *)getDocumentsDirectory;
+(void)moveIconsDirectory;
+(NSString *)getIconsDirectory;

+ (void)showCameraInViewController:(UIViewController*)viewController;
+ (void)showPhotoLibrary:(UIViewController*)viewController;
+ (void)saveIconFromImage:(UIImage*)image completionBlock:(void (^)(BOOL success, NSString* newFileName))completed;
@end
