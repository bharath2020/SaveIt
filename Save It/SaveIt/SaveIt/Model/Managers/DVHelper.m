//
//  DVHelper.m
//  SaveIt
//
//  Created by Bhagya on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVHelper.h"
#import "DVUtilities.h"

#define DV_DATABASE_DIR_NAME @"database"
#define DV_DATABASE_NAME @"savit.db"

static FMDatabaseQueue *sDBQueue = nil;
@implementation DVHelper

+(FMDatabaseQueue*)databaseQueue
{
    if( sDBQueue == nil)
    {
        NSString * docDir = [DVUtilities getDocumentsDirectory];
        //add database folder
        NSString *databaseDirPath = [docDir stringByAppendingPathComponent:DV_DATABASE_DIR_NAME];
        NSString *databasePath = [databaseDirPath stringByAppendingPathComponent:DV_DATABASE_NAME];
        if( ![[NSFileManager defaultManager] fileExistsAtPath:databasePath] )
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:databaseDirPath withIntermediateDirectories:YES attributes:nil error:nil];
            [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"saveit" ofType:@"db"] toPath:databasePath error:nil];
            
        }
        
        sDBQueue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    }
    return sDBQueue;
}

@end
