//
//  DVCategoryManager.m
//  SaveIt
//
//  Created by Bhagya on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVCategoryManager.h"
#import "DVHelper.h"
#import "FMDatabase.h"
#import "DVCategory.h"

//---------Table Keys
#define CATEGORY_ID @"category_id"
#define CATEGORY_NAME @"category_name"
#define CATEGORY_FIELD_NAMES  @"category_fields"
#define CATEGORY_FIELD_SCRAMBLE  @"category_field_scramble"
#define CATEGORY_FIELD_ICON_NAME @"category_icon_name"

NSString * DVCategoriesUpdateNotification = @"categories_update";



@implementation DVCategoryManager

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

//-----------------Methods

-(void)registerForUpdates:(SEL)selector target:(id)observer
{
   @try
    {
        [self unregisterFromUpdates:observer];
        [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:DVCategoriesUpdateNotification object:self];
    }
    @catch(NSException *e)
    {
        
    }
}

-(void)unregisterFromUpdates:(id)target
{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:target name:DVCategoriesUpdateNotification object:self];
    }
    @catch (NSException *exception) {
        
    }
}

-(NSUInteger)totalCategories
{
    return [mObjects count];
}

-(DVCategory *)categoryAtIndex:(NSUInteger)index
{
    DVCategory *category = nil;
    if (index < [mObjects count] )
    {
        category = [mObjects objectAtIndex:index];
    }
    return  category;
}

-(void)loadCategories:(void (^)(BOOL finished))completed
{
    FMDatabaseQueue *dbQueue = [DVHelper databaseQueue];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *reverse){
        FMResultSet *result = [db executeQuery:@"SELECT * FROM CATEGORY"];
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        
        while ([result next]) {
            DVCategory *category = [[DVCategory alloc]init];
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

#pragma Category Manipulate Method
-(void)addCategory:(DVCategory*)newCategory
{
    FMDatabaseQueue *dbQueue = [DVHelper databaseQueue];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *reverse){
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO CATEGORY(%@, %@, %@, %@) VALUES('%@', '%@', '%@', '%@' )", CATEGORY_NAME, CATEGORY_FIELD_NAMES,CATEGORY_FIELD_SCRAMBLE, CATEGORY_FIELD_ICON_NAME , newCategory.categoryName, [newCategory fieldValueString], [newCategory scrambleString], newCategory.iconName ];
        NSLog(@"%@", query);
        BOOL status = [db executeUpdate:query];
        if( status )
        {
            newCategory.categoryID = [db lastInsertRowId];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [mObjects addObject:newCategory];
            [[NSNotificationCenter defaultCenter ] postNotificationName:DVCategoriesUpdateNotification object:self];
        });
    }];
}

-(void)removeCategory:(DVCategory*)category
{
    FMDatabaseQueue *dbQueue = [DVHelper databaseQueue];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *reverse){
        if( [category hasCategoryID] )
        {
            BOOL status = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM CATEGORY WHERE %@ = %u", CATEGORY_ID, category.categoryID]];
            if( status )
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mObjects removeObject:category];
                    [[NSNotificationCenter defaultCenter ] postNotificationName:DVCategoriesUpdateNotification object:self];
                });
            }
        }
    }];
}

@end
