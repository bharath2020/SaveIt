//
//  DVImageManager.m
//  SaveIt
//
//  Created by Bharath Booshan on 6/26/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVImageManager.h"
#import "DVUtilities.h"

@interface DVImageManager()
{
    NSString *_rootDirectory;
    NSMutableArray *_directoryContents;
}
@end

static DVImageManager * sImageManager = nil;
@implementation DVImageManager

//i know its crappy way of implementing singleton, but i am doing as the time factor is less
+ (DVImageManager*)sharedManager
{
    if( sImageManager == nil )
    {
        sImageManager = [[[self class] alloc] init];
    }
    return sImageManager;
}


-(id)init
{
    self = [super init];
    if (self )
    {
        _directoryContents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadImageFromDirectory:(NSString*)rootDirectory completionBlock:(void (^)(BOOL completed))completedBlock
{
    _rootDirectory = rootDirectory;
    [_directoryContents removeAllObjects];
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_rootDirectory error:nil];
    for( NSString * fileName in directoryContents )
    {
        if( [fileName hasSuffix:@".png"] || [fileName hasSuffix:@".PNG"] )
        {
            [_directoryContents addObject:fileName];
        }
    }
    completedBlock(YES);
}

- (NSUInteger)totalImages
{
    return [_directoryContents count];    
}

- (NSString *)imagePathAtIndex:(NSUInteger)index
{
    NSString *filePath = nil;
    if( index < [_directoryContents count] )
    {
        filePath = [_directoryContents objectAtIndex:index];
    }
    return filePath;
}

- (void)addImage:(UIImage *)image completionBlock:(void (^)(BOOL completed))completed
{
    [DVUtilities saveIconFromImage:image completionBlock:^(BOOL success, NSString *newFileName){
        if( success )
        {
            [_directoryContents addObject:newFileName];
            completed(success);
        }
    }];
}

@end
