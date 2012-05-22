//
//  DVHelper.h
//  SaveIt
//
//  Created by Bhagya on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DVHelper : NSObject


+(FMDatabaseQueue*)databaseQueue;
@end
