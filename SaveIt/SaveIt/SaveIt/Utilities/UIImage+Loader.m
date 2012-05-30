//
//  UIImage+Loader.m
//  SaveIt
//
//  Created by Bharath Booshan on 5/29/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "UIImage+Loader.h"
#import "DVUtilities.h"

@implementation UIImage (Loader)
+ (UIImage*)imageFromDocuments:(NSString*)fileName
{
    NSString *documentsDirectory = [DVUtilities getDocumentsDirectory];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return  [UIImage imageWithContentsOfFile:imagePath];
}
@end
