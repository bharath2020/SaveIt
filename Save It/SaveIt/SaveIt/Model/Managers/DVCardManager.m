//
//  DVCardManager.m
//  SaveIt
//
//  Created by Bharath Booshan on 5/21/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVCardManager.h"
#import "DVHelper.h"
#import "DVCard.h"

NSString * DVCardsUpdateNotificationEvent = @"cards_update";

@implementation DVCardManager

//-----------------Init
-(id)init
{
    self = [super init];
    if( self )
    {
        mObjects = [[NSMutableArray alloc] init];
    }
    return self;
}

//-----------------------methods
-(void)registerForUpdates:(SEL)selector target:(id)observer
{
    @try
    {
        [self unregisterFromUpdates:observer];
        [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:DVCardsUpdateNotificationEvent object:self];
    }
    @catch(NSException *e)
    {
        
    }
}

-(void)unregisterFromUpdates:(id)target
{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:target name:DVCardsUpdateNotificationEvent object:self];
    }
    @catch (NSException *exception) {
        
    }
}

-(NSUInteger)totalCards
{
    return [mObjects count];
}


-(DVCard *)cardAtIndex:(NSUInteger)index
{
    DVCard *category = nil;
    if (index < [mObjects count] )
    {
        category = [mObjects objectAtIndex:index];
    }
    return  category;
}

-(void)loadCards:(void (^)(BOOL finished))completed
{
    FMDatabaseQueue *dbQueue = [DVHelper databaseQueue];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *reverse){
        FMResultSet *result = [db executeQuery:@"SELECT * FROM CATEGORY"];
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        
        while ([result next]) {
            DVCard *category = [[DVCard alloc]init];
            category.categoryID = [result unsignedLongLongIntForColumn:CATEGORY_ID];
            category.categoryName = [result stringForColumn:CATEGORY_NAME];
            [category setFieldNames:[result stringForColumn:CATEGORY_FIELD_NAMES] scramble:[result stringForColumn:CATEGORY_FIELD_SCRAMBLE]];
            category.iconName = [result stringForColumn:CATEGORY_FIELD_ICON_NAME];
            [categoryArray addObject:category];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mObjects removeAllObjects];
            [mObjects addObjectsFromArray:categoryArray];
            [[NSNotificationCenter defaultCenter ] postNotificationName:DVCategoriesUpdateNotification object:self];
        });
    }];
}


@end
