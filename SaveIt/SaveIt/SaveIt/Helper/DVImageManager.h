//
//  DVImageManager.h
//  SaveIt
//
//  Created by Bharath Booshan on 6/26/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVImageManager : NSObject

+ (DVImageManager*)sharedManager;
- (void)loadImageFromDirectory:(NSString*)rootDirectory completionBlock:(void (^)(BOOL completed))completedBlock;
- (NSUInteger)totalImages;
- (NSString *)imagePathAtIndex:(NSUInteger)index;
- (void)addImage:(UIImage *)image completionBlock:(void (^)(BOOL completed))completed;
@end
