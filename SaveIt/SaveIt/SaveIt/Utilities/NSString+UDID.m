//
//  NSString+UDID.m
//  SaveIt
//
//  Created by Bharath Booshan on 6/29/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "NSString+UDID.h"

@implementation NSString (UDID)
+ (NSString *)uuid
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return uuidString;
}
@end
